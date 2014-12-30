Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaL3MyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:54:09 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60645 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaL3MyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:54:07 -0500
Message-ID: <54A2A06C.203@gmail.com>
Date: Tue, 30 Dec 2014 13:54:04 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laurent Georget <laurent.georget@supelec.fr>,
        linux-man <linux-man@vger.kernel.org>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] adjtimex.2: add fields in struct timex description
References: <547AEE16.20603@supelec.fr>
In-Reply-To: <547AEE16.20603@supelec.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Laurent,

Sorry for the delayed follow up...

On 11/30/2014 11:14 AM, Laurent Georget wrote:
> Hello,
> 
> this is a refactored series of patches for adjtimex(2) man page. Please
> ignore all previous patches I sent for adjtimex.2.

Thanks for the clear note about disregarding previous versions. That
makes things much simpler for me.

> The first patch updates the man page with the new fields added in struct
> timex since last edition of the man page.
> 
> Thank you for your time. These are my first patches so you may have to
> bear with me being a little inexpert and clumsy for some time. I
> apologize for that.

I've applied the patch. Note one point/question below.

> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index eb3fda1..0b919c5 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -73,6 +73,15 @@ struct timex {
>                              (read-only) */
>      struct timeval time; /* current time (read-only) */
>      long tick;           /* usecs between clock ticks */
> +    long ppsfreq;        /* pps frequency (scaled ppm) (read-only) */
> +    long jitter;         /* pps jitter (usec) (read-only) */
> +    int shift;           /* interval duration (sec) (read-only) */
> +    long stabil;         /* pps stability (scaled ppm) (read-only) */
> +    long jitcnt;         /* jitter limit exceeded (read-only) */
> +    long calcnt;         /* calibration intervals (read-only) */
> +    long errcnt;         /* calibration errors (read-only) */
> +    long stbcnt;         /* stability limit exceeded (read-only) */
> +    int tai;             /* TAI offset (s) (read-only) */
>  };

Presumably, '(s)' means seconds, right? 

I changed this to to '(sec)' for consistency with the other 
comments above.

Thanks,

Michael`


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
