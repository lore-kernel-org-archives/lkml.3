Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaLEVDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:03:43 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50811 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaLEVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:03:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
Date: Fri, 05 Dec 2014 22:03:31 +0100
Message-ID: <2110446.Lbe6oKjkNj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1412051251280.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <alpine.LFD.2.11.1412051251280.470@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:dRqvx1QLbR0Rz4rt15rWQxNSMs22mzfRXXshO3APDQJScbCCyPg
 pah/9+CNyAHpcPYja0ilG6ls9w0I4GKArAzx+w7fML9o86LtHaQ1+wBmwSTcIv2CtC4gXuq
 wf3hNK0fGbunAodwpRnhvA8bOQuKtRXcdKmmY9xG2uk1eyEkRBRqy8JibvAbTrvIYiaLGp3
 mP8ptIMHSrXjmHI58eHgg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 13:00:22 Nicolas Pitre wrote:
> 
> BTW this is worth applying despite the on-going discussion with Arnd 
> on a separate optimization.

Agreed

> On Wed, 3 Dec 2014, Nicolas Pitre wrote:
> 
> > At least on ARM, do_div() is optimized to turn constant divisors into
> > an inline multiplication by the reciprocal value at compile time. 
> > However this optimization is missed entirely whenever ktime_divns() is
> > used and the slow out-of-line division code is used all the time.
> > 
> > Let ktime_divns() use do_div() inline whenever the divisor is constant
> > and small enough.  This will make things like ktime_to_us() and 
> > ktime_to_ms() much faster.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
