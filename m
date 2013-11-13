Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3KMMf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:35:57 -0500
Received: from smtp03.stone-is.org ([87.238.162.6]:55169 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3KMMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:35:52 -0500
X-Greylist: delayed 1742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 07:35:52 EST
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52836B53.4080204@acm.org>
Date: Wed, 13 Nov 2013 13:06:43 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Decotigny <decot@googlers.com>, linux-scsi@vger.kernel.org
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
References: <cover.1384304973.git.decot@googlers.com> <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
In-Reply-To: <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 02:10, David Decotigny wrote:
> This patch avoids to use an object after it was potentially reclaimed
> by scsi_device_put().
>
> Signed-off-by: David Decotigny <decot@googlers.com>
> ---
>   drivers/scsi/scsi_scan.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 307a811..16e4a44 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1498,12 +1498,14 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>    out_err:
>   	kfree(lun_data);
>    out:
> -	scsi_device_put(sdev);
> -	if (scsi_device_created(sdev))
> +	if (scsi_device_created(sdev)) {
>   		/*
>   		 * the sdev we used didn't appear in the report luns scan
>   		 */
>   		__scsi_remove_device(sdev);
> +	}
> +
> +	scsi_device_put(sdev);
>   	return ret;
>   }

It would help if you could explain why you started looking at this code. 
Is the above patch something you came up with after having analyzed the 
SCSI mid-layer source code or perhaps as the result of a test that 
failed ? If so, which test was it that failed ?

Thanks,

Bart.

