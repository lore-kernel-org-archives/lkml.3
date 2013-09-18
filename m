Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3IRDZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:25:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38217 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3IRDZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:25:29 -0400
Message-ID: <52391D21.6080703@oracle.com>
Date: Tue, 17 Sep 2013 22:25:21 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>
Subject: Re: linux-next: manual merge of the vfs tree with the aio-direct
 tree
References: <20130918105638.6fa7c29605c14b408b7f5a7e@canb.auug.org.au> <20130918020035.GK13318@ZenIV.linux.org.uk>
In-Reply-To: <20130918020035.GK13318@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 09:00 PM, Al Viro wrote:
> On Wed, Sep 18, 2013 at 10:56:38AM +1000, Stephen Rothwell wrote:
>> Hi Al,
>>
>> Today's linux-next merge of the vfs tree got conflicts in fs/nfs/direct.c
>> and fs/nfs/file.c between commits b9517433d65d ("dio: Convert direct_IO
>> to use iov_iter"), a8431c667ae8 ("nfs: add support for read_iter,
>> write_iter") and a1b8ec384b73 ("nfs: simplify swap") from the aio-direct
>> tree and commit c18d1ec44f7a ("nfs: use %p[dD] instead of open-coded (and
>> often racy) equivalents") from the vfs tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
> 
> Hrm...  FWIW, I would greatly prefer to offload these printk patches to
> NFS and NFSD trees.  Didn't get around to that yet, but...
> 
> As for aio-direct...  Two questions:
> 	* had anybody tried to measure the effect on branch predictor from
> introducing that method vector?  Commit d6afd4c4 ("iov_iter: hide iovec
> details behind ops function pointers")

Any suggestions for a good benchmark?

> 	* WTF does aforementioned commit lack its author's s-o-b?  The same
> goes for a lot of zab's commits in there...

That would be my bad. Zach's original patches had his s-o-b (w/an Oracle
email address). I'll add them back.

Shaggy
