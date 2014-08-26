Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaHZCoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:44:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62945 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaHZCoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:44:23 -0400
X-AuditID: cbfee61a-f79e46d00000134f-9a-53fbf485abb5
From: Chao Yu <chao2.yu@samsung.com>
To: "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <001201cfb838$fb0ac4a0$f1204de0$@samsung.com>
 <20140815061138.GA940@swordfish> <002d01cfbb70$ea7410c0$bf5c3240$@samsung.com>
 <20140819112500.GA2484@swordfish> <20140820020924.GD32620@bbox>
 <006701cfbc4f$c9d2fe00$5d78fa00$@samsung.com> <20140821011854.GE17372@bbox>
 <001601cfbd1f$b9f068d0$2dd13a70$@samsung.com> <20140821130504.GB946@swordfish>
In-reply-to: <20140821130504.GB946@swordfish>
Subject: RE: [PATCH] zram: add num_discards for discarded pages stat
Date: Tue, 26 Aug 2014 10:43:21 +0800
Message-id: <007f01cfc0d7$a4ddba90$ee992fb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLPTAw4onMCo+gZju9DfYrrOaResgJq92h2AoAbnpACr8Gx1gD+LFnWAcLEllkBgb8xrQImdvPSAoBACpeZXvG5IA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoG7rl9/BBhOWSVnMWb+GzeLUn+tM
	Fpd3zWGzuLfmP6vFsq/v2S02tMxit1j7+TG7A7vHzll32T02repk89j0aRK7x4kZv1k83u+7
	yuax89NmVo/Pm+QC2KO4bFJSczLLUov07RK4MiZ+ky/o0q5o2vKHuYFxrnIXIyeHhICJxN8J
	jUwQtpjEhXvr2boYuTiEBKYzSnzfvokRwvnBKHFuzyx2kCo2ARWJ5R3/wTpEBMwl2vYfButg
	FjjOKNF8op8ZouM1k8SqVxvAOjgFdCWmdT0Ds4UFXCSe3b8LZrMIqEpsWLkFaAUHB6+ApcSL
	rQ4gYV4BQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGqgsSOs68ZIY7Ikdi/q4cRokZcYuOR
	WywTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcAw9k9rB
	uLLB4hCjAAejEg/vjfjfwUKsiWXFlbmHGCU4mJVEeBkeAoV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwzjn46tDy4wzHrynPXWW+7N7089KOeoWMp/9z
	y1W0bN38WqawclHUZSNVs58cn71FnnbYcIdMF+ri8LHYzbDi3ErppBVT2Nw6D3p2rpfs8mp6
	/HT+Fm/3rXZsUgxfSvNeXOBdzXHPhPu4zT5D+cOm51zOzHCQqj8jfjw8669Orsz5xuKCg8cz
	lViKMxINtZiLihMBN6mgtp0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On Behalf Of Sergey
> Senozhatsky
> Sent: Thursday, August 21, 2014 9:05 PM
> To: Chao Yu
> Cc: 'Minchan Kim'; 'Sergey Senozhatsky'; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> ngupta@vflare.org; 'Jerome Marchand'; 'Andrew Morton'
> Subject: Re: [PATCH] zram: add num_discards for discarded pages stat
> 
> On (08/21/14 17:09), Chao Yu wrote:
> [cut]
> > >
> > > I hope I'm not discouraging. :)
> >
> > Nope, please let me try again, :)
> >
> > Since we have supported handling discard request in this commit
> > f4659d8e620d08bd1a84a8aec5d2f5294a242764 (zram: support REQ_DISCARD), zram got
> > one more chance to free unused memory whenever received discard request. But
> > without stating for discard request, there is no method for user to know whether
> > discard request has been handled by zram or how many blocks were discarded by
> > zram when user wants to know the effect of discard.
> >
> > In this patch, we add num_discards to stat discarded pages, and export it to
> > sysfs for users.
> >
> 
> In other words, here is my proposal:
> 
> -----8<-----8<-----
> 
> Subject: [PATCH] zram: use notify_free to account all free notifications
> 
> notify_free device attribute accounts the number of slot free notifications
> and internally represents the number of zram_free_page() calls. Slot free
> notifications are sent only when device is used as a swap device, hence
> notify_free is used only for swap devices. Since f4659d8e620d08 (zram:
> support REQ_DISCARD) ZRAM handles yet another one free notification (also
> via zram_free_page() call) -- REQ_DISCARD requests, which are sent by a
> filesystem, whenever some data blocks are discarded. However, there is no
> way to know the number of notifications in the latter case.
> 
> Use notify_free to account the number of pages freed in zram_free_page(),
> instead of accounting only swap_slot_free_notify() calls (each
> zram_slot_free_notify() call frees one page).
> 
> This means that depending on usage scenario notify_free represents:
>  a) the number of pages freed because of slot free notifications, which is
>    equal to the number of swap_slot_free_notify() calls, so there is no
>    behaviour change

As I know, administrator can send discard request by using "swapon -d /dev/zram0"
So after then, notify_free may show the page number mixed with both result of
handling REQ_DISCARD and slot free notifications.

And as I check the code, there is a workqueue "swap_discard_work" inited
in sys_swapon, so maybe there are REQ_DISCARDs sent from background thread,
but not filesystem. Is this right?

Regards,
Yu

> 
>  b) the number of pages freed because of REQ_DISCARD notifications
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-block-zram | 13 ++++++++-----
>  drivers/block/zram/zram_drv.c              |  2 +-
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-block-zram
> b/Documentation/ABI/testing/sysfs-block-zram
> index 70ec992..73ed400 100644
> --- a/Documentation/ABI/testing/sysfs-block-zram
> +++ b/Documentation/ABI/testing/sysfs-block-zram
> @@ -77,11 +77,14 @@ What:		/sys/block/zram<id>/notify_free
>  Date:		August 2010
>  Contact:	Nitin Gupta <ngupta@vflare.org>
>  Description:
> -		The notify_free file is read-only and specifies the number of
> -		swap slot free notifications received by this device. These
> -		notifications are sent to a swap block device when a swap slot
> -		is freed. This statistic is applicable only when this disk is
> -		being used as a swap disk.
> +		The notify_free file is read-only. Depending on device usage
> +		scenario it may account a) the number of swap slot free
> +		notifications or b) the number of REQ_DISCARD requests sent
> +		by bio. The former ones are sent to a swap block device when a
> +		swap slot is freed, which implies that this disk is being used
> +		as a swap disk. The latter ones are sent by filesystem mounted
> +		with discard option, whenever some data blocks are getting
> +		discarded.
> 
>  What:		/sys/block/zram<id>/zero_pages
>  Date:		August 2010
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index d00831c..c2e7127 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -344,6 +344,7 @@ static void zram_free_page(struct zram *zram, size_t index)
>  	atomic64_sub(zram_get_obj_size(meta, index),
>  			&zram->stats.compr_data_size);
>  	atomic64_dec(&zram->stats.pages_stored);
> +	atomic64_inc(&zram->stats.notify_free);
> 
>  	meta->table[index].handle = 0;
>  	zram_set_obj_size(meta, index, 0);
> @@ -843,7 +844,6 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
>  	zram_free_page(zram, index);
>  	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
> -	atomic64_inc(&zram->stats.notify_free);
>  }
> 
>  static const struct block_device_operations zram_devops = {
> --
> 2.1.0.233.g9eef2c8
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

