Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaGLTkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:40:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:33331 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaGLTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:40:11 -0400
Date: Sat, 12 Jul 2014 21:40:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 35/55] mfd: cros_ec_spi: Use ktime_get_ns()
In-Reply-To: <20140711145212.GG2954@lee--X1>
Message-ID: <alpine.DEB.2.10.1407122134470.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133708.263040802@linutronix.de> <20140711145212.GG2954@lee--X1>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Lee Jones wrote:

> > Replace the ever recurring:
> > 	ts = ktime_get_ts();
> > 	ns = timespec_to_ns(&ts);
> > with
> > 	ns = ktime_get_ns();
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> Only Sam?  How old is your version of MAINTAINERS?

Hmm. I use get_maintainers.pl and manually edit it afterwards. Seems
that I killed one extra line :)
 
> Sam hasn't actively maintained MFD for over a year now.
> 
> Patch applied though, thanks.

ktime_get_ns() is not upstream yet, it's part of the series I posted :)

If you ack it, i'll carry it and also remove the now unused variable
ts before applying it.

Thanks,

	tglx


