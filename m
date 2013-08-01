Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3HAKVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:21:37 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:33950 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3HAKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:21:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="7357621"
Message-ID: <51FA36AC.1090609@citrix.com>
Date: Thu, 1 Aug 2013 12:21:32 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC] p2m: use GNTTABOP_unmap_and_duplicate
 if	available
References: <1375286855-4861-1-git-send-email-roger.pau@citrix.com> <51FA302B.90106@citrix.com>
In-Reply-To: <51FA302B.90106@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 11:53, David Vrabel wrote:
> On 31/07/13 17:07, Roger Pau Monne wrote:
>> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
>> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
>> code without requiring the use of a multicall.
> 
> Thanks. This looks like it should be a good performance improvement for
> userspace-based backends.  Do you have any performance measurements for
> (e.g.) qemu's disk backend?

Not yet, I might be able to get some initial performance measurements
tomorrow.

> 
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
> [...]
>> +int m2p_remove_override_batch(struct page **pages,
>> +		struct gnttab_map_grant_ref *kmap_ops, int count)
>> +{
> 
> Is it possible to refactor this function and
> m2p_remove_override_single() to share some common helper functions?

Yes, I will split those common parts into inline functions and share
them between both implementations.

Roger.
