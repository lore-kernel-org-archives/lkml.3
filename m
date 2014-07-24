Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbaGXFkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:40:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaGXFkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:40:41 -0400
Message-ID: <53D09C54.1000206@suse.de>
Date: Thu, 24 Jul 2014 07:40:36 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1405983961-18782-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 01:06 AM, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>   drivers/scsi/storvsc_drv.c |   10 ++++++++++
>   1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 29d0329..15ba695 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -327,6 +327,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>    */
>   static int storvsc_timeout = 180;
>
> +static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
> +
>   #define STORVSC_MAX_IO_REQUESTS				200
>
>   static void storvsc_on_channel_callback(void *context);
> @@ -1449,6 +1451,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>
>   	sdevice->no_write_same = 1;
>
> +	/*
> +	 * Add blist flags to permit the reading of the VPD pages even when
> +	 * the target may claim SPC-2 compliance. MSFT targets currently
> +	 * claim SPC-2 compliance while they implement post SPC-2 features.
> +	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 */
> +	sdevice->sdev_bflags |= msft_blist_flags;
> +
>   	return 0;
>   }
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
