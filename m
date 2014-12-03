Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaLCUQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:16:35 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:45259 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:16:34 -0500
X-ME-Helo: beldin
X-ME-Date: Wed, 03 Dec 2014 21:16:31 +0100
X-ME-IP: 109.214.46.91
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 03 Dec 2014 21:16:27 +0100
In-Reply-To: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> (Nicolas Pitre's
	message of "Wed, 3 Dec 2014 14:43:06 -0500 (EST)")
Message-ID: <87zjb4zdyc.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nicolas.pitre@linaro.org> writes:

> Let ktime_divns() use do_div() inline whenever the divisor is constant
> and small enough.  This will make things like ktime_to_us() and 
> ktime_to_ms() much faster.

Hi Nicolas,

I suppose the "small enough" is linked to the "!(div >> 32)" in your patch.  Can
I have the rationale which brought up this value, and if that value is universal
across architectures (ie. x86/ppc/arm/...) ?

And when you say "much faster", do you have figures to add to your commit
message ?

Cheers.

--
Robert
