Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaJ2JVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:21:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:55043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbaJ2JVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:21:21 -0400
Date: Wed, 29 Oct 2014 10:21:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heena Sirwani <heenasirwani@gmail.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de
Subject: Re: [PATCH v7] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <20141029091317.GA1138@heena-HP-Compaq-8200-Elite-MT-PC>
Message-ID: <alpine.DEB.2.11.1410291020140.5308@nanos>
References: <20141029091317.GA1138@heena-HP-Compaq-8200-Elite-MT-PC>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Heena Sirwani wrote:
> +time64_t ktime_get_seconds(void)
> +{
> +	time64_t seconds;
> +	struct timekeeper *tk = &tk_core.timekeeper;
> +	unsigned int seq;
> +
> +	WARN_ON(timekeeping_suspended);

You want to have the same 64bit logic as you did for
ktime_get_real_seconds. So on 64bit it boils down to return
tk->ktime_sec.

> +
> +	do {
> +		seq = read_seqcount_begin(&tk_core.seq);
> +		seconds = tk->ktime_sec;
> +
> +	} while (read_seqcount_retry(&tk_core.seq, seq));
> +
> +	return seconds;
> +}

Thanks,

	tglx
