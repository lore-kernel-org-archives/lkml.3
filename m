Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3CKPRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:17:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47596 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3CKPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130311145435.GB26394@phenom.dumpdata.com>
References: <1363001016-8439-1-git-send-email-mihneadb@gmail.com>
	<20130311145435.GB26394@phenom.dumpdata.com>
Date: Mon, 11 Mar 2013 17:17:02 +0200
Message-ID: <CAEnQRZBZr+7tLxmSL44q8avpDX7x2yG36ruQAv+9diudhQF_kQ@mail.gmail.com>
Subject: Re: [PATCH] block: replace kmalloc and then memcpy with kmemdup
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

The performance is the same using kmemdup, but we have the following advantages:
* code is cleaner
* kmemdup adds additional debugging info useful for tracking the real
place where memory was allocated [1] [2].

thanks,
Daniel.

[1] http://lxr.linux.no/#linux+v3.8.2/mm/util.c#L61
[2] http://lxr.linux.no/#linux+v3.8.2/include/linux/slab.h#L363

On Mon, Mar 11, 2013 at 4:54 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Mar 11, 2013 at 01:23:36PM +0200, Mihnea Dobrescu-Balaur wrote:
>
> Are there performance improvements to doing it this way?
>
>> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
>> ---
>>  drivers/block/xen-blkfront.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index c3dae2e..9620644 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -1203,11 +1203,10 @@ static int blkif_recover(struct blkfront_info *info)
>>       int j;
>>
>>       /* Stage 1: Make a safe copy of the shadow state. */
>> -     copy = kmalloc(sizeof(info->shadow),
>> +     copy = kmemdup(info->shadow, sizeof(info->shadow),
>>                      GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
>>       if (!copy)
>>               return -ENOMEM;
>> -     memcpy(copy, info->shadow, sizeof(info->shadow));
>>
>>       /* Stage 2: Set up free list. */
>>       memset(&info->shadow, 0, sizeof(info->shadow));
>> --
>> 1.7.10.4
>>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
