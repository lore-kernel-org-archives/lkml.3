Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3EBIWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:22:21 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:52605 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3EBIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:22:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4146175"
Message-ID: <51822235.80002@citrix.com>
Date: Thu, 2 May 2013 10:22:13 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkback: allocate list of pending reqs in small chunks
References: <1366983947-54578-1-git-send-email-roger.pau@citrix.com> <517A938C.6060703@citrix.com> <20130429183741.GE9431@phenom.dumpdata.com>
In-Reply-To: <20130429183741.GE9431@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/13 20:37, Konrad Rzeszutek Wilk wrote:
> On Fri, Apr 26, 2013 at 03:47:40PM +0100, David Vrabel wrote:
>> On 26/04/13 14:45, Roger Pau Monne wrote:
>>> Allocate pending requests in smaller chunks instead of allocating them
>>> all at the same time.
>>>
>>> This change also removes the global array of pending_reqs, it is no
>>> longer necessay.
>>>
>>> Variables related to the grant mapping have been grouped into a struct
>>> called "grant_page", this allows to allocate them in smaller chunks,
>>> and also improves memory locality.
>>>
>> [...]
>>> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
>>> index afab208..2841c0f 100644
>>> --- a/drivers/block/xen-blkback/xenbus.c
>>> +++ b/drivers/block/xen-blkback/xenbus.c
>>> @@ -127,22 +128,53 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>>>         blkif->free_pages_num = 0;
>>>         atomic_set(&blkif->persistent_gnt_in_use, 0);
>>>
>>> -       blkif->pending_reqs = kcalloc(XEN_BLKIF_REQS,
>>> -                                     sizeof(blkif->pending_reqs[0]),
>>> -                                     GFP_KERNEL);
>>> -       if (!blkif->pending_reqs) {
>>> -               kmem_cache_free(xen_blkif_cachep, blkif);
>>> -               return ERR_PTR(-ENOMEM);
>>> -       }
>>>         INIT_LIST_HEAD(&blkif->pending_free);
>>> +
>>> +       pr_alert("sizeof req: %lu\n", sizeof(*req));
>>
>> Stray pr_alert() here.
>>
>> Looks good otherwise.
>>
>> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> Roger, could you repost it please and also include Tested-by: Sander.. on it
> please?

Done, see v3.

