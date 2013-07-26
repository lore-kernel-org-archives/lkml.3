Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3GZK03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:26:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55556 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3GZK01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:26:27 -0400
Date: Fri, 26 Jul 2013 12:26:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Dave Hansen <dave@sr71.net>, x86@kernel.org
Subject: Re: [PATCH] x86, tsc add an initial read offset to __cycles_2_ns()
 calculations
Message-ID: <20130726102622.GA26073@pd.tnic>
References: <1374681800-7237-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374681800-7237-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:03:20PM -0400, Prarit Bhargava wrote:
> +/*
> + * TSC can have non-zero values at boot time on Intel Xeon E5 (family 6,
> + * model 45) aka "SandyBridge" processors.  This is documented in the
> + * Errata for the processors as BT81.  As a result, we need to snapshot
> + * the TSC's initial value to avoid calculation overflows in the conversions
> + * of cycles to nanoseconds.
> + */
> +unsigned long long tsc_initial_value;
> +
>  /*
>   * Scheduler clock - returns current time in nanosec units.
>   */
> @@ -979,6 +989,9 @@ void __init tsc_init(void)
>  		return;
>  	}
>  
> +	tsc_initial_value = get_cycles();
> +	pr_info("TSC: tsc initial value = %lld\n", tsc_initial_value);
> +

And we probably don't need that info on processors unaffected by the
erratum...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
