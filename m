Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3EOJlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:41:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:56259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3EOJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:41:50 -0400
Date: Wed, 15 May 2013 11:41:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 06/15] clocksource: Split out user string input
In-Reply-To: <517F026D.2080701@linaro.org>
Message-ID: <alpine.LFD.2.02.1305151141280.1388@ionos>
References: <20130425142452.908423538@linutronix.de> <20130425143435.895851338@linutronix.de> <517F026D.2080701@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, John Stultz wrote:
> On Thu, Apr 25, 2013 at 1:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> So you probably want something like the following patch to fix this.

Yep, stupid me.
 
> thanks
> -john
> 
> 
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index e9c4f04..5f6c324 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -836,6 +836,8 @@ sysfs_show_current_clocksources(struct device *dev,
> 
>  static size_t clocksource_get_uname(const char *buf, char *dst, size_t cnt)
>  {
> +	size_t ret = cnt;
> +
>  	/* strings from sysfs write are not 0 terminated! */
>  	if (!cnt || cnt >= CS_NAME_LEN)
>  		return -EINVAL;
> @@ -846,7 +848,7 @@ static size_t clocksource_get_uname(const char *buf, char
> *dst, size_t cnt)
>  	if (cnt > 0)
>  		memcpy(dst, buf, cnt);
>  	dst[cnt] = 0;
> -	return cnt;
> +	return ret;
>  }
> 
>  /**
> 
