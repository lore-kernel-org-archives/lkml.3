Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaIOTPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbaIOTPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:15:35 -0400
Message-ID: <54173ABD.40207@redhat.com>
Date: Mon, 15 Sep 2014 21:15:09 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Hans de Goede <hdegoede@redhat.com>, linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fix regression that accidentally disabled block-based
 tcq
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com> <20140910154535.GA5102@infradead.org> <541172E9.8070309@redhat.com> <20140911161331.GA24488@infradead.org> <54134E50.6040805@redhat.com> <20140912230032.GA21143@infradead.org>
In-Reply-To: <20140912230032.GA21143@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/12/14 7:00 PM, Christoph Hellwig wrote:
> Please try the fix below, looks like the commit broke TCQ for all drivers
> using block-level tagging.
>
> ---
>  From 865a19b760d2786fe37d3b5c151a4ecea4c0e95e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 12 Sep 2014 16:00:19 -0700
> Subject: scsi: fix regression that accidentally disabled block-based tcq
>
> The scsi blk-mq support accidentally flipped a conditional, which lead to
> never enabling block based tcq when using the legacy request path.
>
> Fixes: d285203cf647d7c9 scsi: add support for a blk-mq based I/O path.
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/scsi/scsi_tcq.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index cdcc90b..e645835 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -68,7 +68,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
>   		return;
>   
>   	if (!shost_use_blk_mq(sdev->host) &&
> -	    blk_queue_tagged(sdev->request_queue))
> +	    !blk_queue_tagged(sdev->request_queue))
>   		blk_queue_init_tags(sdev->request_queue, depth,
>   				    sdev->host->bqt);
>   

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
