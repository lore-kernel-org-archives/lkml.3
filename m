Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3BHFlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:41:37 -0500
Received: from relay.parallels.com ([195.214.232.42]:58500 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3BHFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:41:35 -0500
Message-ID: <51148FF1.4040108@parallels.com>
Date: Fri, 8 Feb 2013 09:41:05 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the nfsd tree
References: <20130202130403.a29346b583a802ed6ce6880b@canb.auug.org.au> <20130202125719.GF30668@fieldses.org> <20130203144123.GA22854@fieldses.org>
In-Reply-To: <20130203144123.GA22854@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.02.2013 18:41, J. Bruce Fields пишет:
> On Sat, Feb 02, 2013 at 07:57:19AM -0500, J. Bruce Fields wrote:
>> On Sat, Feb 02, 2013 at 01:04:03PM +1100, Stephen Rothwell wrote:
>>> Hi,
>>>
>>> After merging the nfsd tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>>
>>> fs/nfs/dns_resolve.c: In function 'nfs_dns_resolver_cache_init':
>>> fs/nfs/dns_resolve.c:375:4: error: 'struct cache_detail' has no member named 'cache_upcall'
>>> fs/nfs/dns_resolve.c:375:35: warning: left-hand operand of comma expression has no effect [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
>>>
>>> Caused by commit aab982cb5dfb ("SUNRPC: remove cache_detail->cache_upcall
>>> callback").
>>
>> Yes, I knew why we'd introduced cache_upcall, so I'm not sure how I
>> overlooked that.  It must have slipped through testing because I didn't
>> set CONFIG_NFS_USE_KERNEL_DNS.
>>
>> We may just be able to revert that patch....  I can take care of that by
>> tomorrow.
>
> Stanislav, any objections to this?
>

The only objection is that I've sent you the patch set witch fixes all these problems already:

"[PATCH v2 0/6] SUNRPC: rework cache upcall to avoid NFSd root". :)

The only reason why I removed cache_upcall at all was that all it's users (except NFS DNS cache - my mistake) just call sunrpc_cache_pipe_upcall and thus these 
wrapper looked redundant to me.
Second patch set leaves cache_upcall only for NFS DNS cache (since this upcall is not just a wrapper around sunrpc_cache_pipe_upcall).
And second patch set implies the first one will be dropped.
I can, actually, send one more (incremental  this time) patch set to fix the problem, if you wish.

But it's up to you, what to commit, Bruce.

-- 
Best regards,
Stanislav Kinsbursky
