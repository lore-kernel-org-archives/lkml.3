Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbbAFPTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:19:11 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65230 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbAFPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:19:09 -0500
Message-ID: <54ABFCE4.4050804@gmail.com>
Date: Tue, 06 Jan 2015 16:19:00 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laurent Georget <laurent.georget@supelec.fr>,
        linux-man <linux-man@vger.kernel.org>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        Jeff Epler <jepler@unpythonic.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/2] adjtimex.2: Clarify the 'ppm scaling' used in struct
 timex
References: <54A2DEAD.2050708@supelec.fr> <54A72360.3070807@supelec.fr>
In-Reply-To: <54A72360.3070807@supelec.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 01/03/2015 12:01 AM, Laurent Georget wrote:
> Hi,
> 
> this is the last version of a new series of patchs for adjtimex.2.
> Please ignore all previous versions of this series.
> 
> This patch makes explicit and clarifies the unit used for fields 
> "freq", "ppsfreq" and "stabil" in struct timex.
> It closes a FIXME in the man page.

Thanks -- nice work pulling together the input of Richard and Jeff.
Patch applied.

> Reviewed-By: Jeff Epler <jepler@unpythonic.net>

And for good measure I threw in a "Reviewed-by" from Richard as well.

Thanks,

Michael


> 
> ---
>  man2/adjtimex.2 | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index 18823c8..ff4b23e 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -54,9 +54,8 @@ struct timex {
>      long offset;      /* Time offset; nanoseconds, if STA_NANO
>                           status flag is set, otherwise
>                           microseconds */
> -    long freq;        /* Frequency offset, as scaled PPM
> -                         (parts per million) */
> -.\" FIXME What is the scaling unit of timex.freq?  2^16 ?
> +    long freq;        /* Frequency offset, in units of 2^-16 PPM
> +                         (parts per million) (see NOTES below) */
>      long maxerror;    /* Maximum error (microseconds) */
>      long esterror;    /* Estimated error (microseconds) */
>      int  status;      /* Clock command/status */
> @@ -72,13 +71,13 @@ struct timex {
>                           flag is set, otherwise microseconds */
>      long tick;        /* Microseconds between clock ticks */
>      long ppsfreq;     /* PPS (pulse per second) frequency
> -                         (scaled PPM, read-only) */
> +                         (2^-16 PPM (see NOTES), read-only) */
>      long jitter;      /* PPS jitter (read-only); nanoseconds, if
>                           STA_NANO status flag is set, otherwise
>                           microseconds */
>      int  shift;       /* PPS interval duration
>                           (seconds, read-only) */
> -    long stabil;      /* PPS stability (scaled PPM, read-only) */
> +    long stabil;      /* PPS stability (2^-16 PPM (see NOTES), read-only) */
>      long jitcnt;      /* PPS jitter limit exceeded (read-only) */
>      long calcnt;      /* PPS calibration intervals (read-only) */
>      long errcnt;      /* PPS calibration errors (read-only) */
> @@ -343,6 +342,18 @@ and the caller does not have sufficient privilege.
>  Under Linux, the
>  .B CAP_SYS_TIME
>  capability is required.
> +.SH NOTES
> +In struct
> +.IR timex ,
> +.IR freq ,
> +.IR ppsfreq ,
> +and 
> +.I stabil
> +are PPM (parts per million) with a 16-bits fractional part, which means that a
> +value of 1 in one of those fields actually means 2^-16 PPM, and 2^16=65535 is 
> +1 PPM. This is the case for both input values (in the case of
> +.IR freq )
> +and output values.
>  .SH CONFORMING TO
>  .BR adjtimex ()
>  is Linux-specific and should not be used in programs
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
