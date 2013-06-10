Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3FJRrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:47:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36613 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab3FJRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:47:05 -0400
Message-ID: <1370886422.1936.27.camel@dabdike>
Subject: Re: [PATCH RESEND] scsi: Introduce a help function
 local_time_seconds() to simplify the getting time stamp operation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 10 Jun 2013 10:47:02 -0700
In-Reply-To: <51B53293.7090100@cn.fujitsu.com>
References: <51B53293.7090100@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 09:57 +0800, Gu Zheng wrote:
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 66216c1..f3377ca 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -574,4 +574,13 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
>         return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
>  }
>  
> +/*
> + * Convert system time in UTC to local time seconds.
> + */
> +static inline u32 local_time_seconds(void)
> +{
> +       struct timeval utc;
> +       do_gettimeofday(&utc);
> +       return (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
> +}
>  #endif /* _SCSI_SCSI_H */

This doesn't belong in SCSI.

It's not a common pattern, so just leave it open coded in the 3ware
drivers.  If there's a need for it to be a common pattern, John Stultz
will add it to the timer code, but at the moment, he doesn't seem to see
the need.

James


