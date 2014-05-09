Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbaEISR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:17:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54113 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbaEISR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140509201405.7969fa7e0cd39f4f1e4e3149@skynet.be>
References: <20140509201405.7969fa7e0cd39f4f1e4e3149@skynet.be>
Date: Fri, 9 May 2014 11:17:56 -0700
Message-ID: <CALAqxLW7oMJyhZ+a0tHX+KpbinA0f+6vRo2eigE1iuSQk4mERw@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/time/ntp.c: convert simple_strtol to kstrtol
From: John Stultz <john.stultz@linaro.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 11:14 AM, Fabian Frederick <fabf@skynet.be> wrote:
>

Commit message missing.  Mind adding a brief description of why this
change is worth making?

> Inspired-By: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/time/ntp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 419a52c..82b7c9e 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -923,7 +923,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
>
>  static int __init ntp_tick_adj_setup(char *str)
>  {
> -       ntp_tick_adj = simple_strtol(str, NULL, 0);
> +       int rc = kstrtol(str, 0, (long *)&ntp_tick_adj);
> +
> +       if (rc)
> +               return rc;
>         ntp_tick_adj <<= NTP_SCALE_SHIFT;
>
>         return 1;
> --
> 1.8.4.5
>

thanks
-john
