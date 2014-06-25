Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbaFYPxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:53:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56399 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaFYPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:53:13 -0400
Date: Wed, 25 Jun 2014 17:52:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Guenter Roeck'" <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] sched: Fix compiler warnings
Message-ID: <20140625155259.GQ14781@pengutronix.de>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
 <20140625071416.GM14781@pengutronix.de>
 <53AADC63.8080106@roeck-us.net>
 <20140625144955.GP14781@pengutronix.de>
 <53AAE4D2.5020104@roeck-us.net>
 <063D6719AE5E284EB5DD2968C1650D6D17265D81@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17265D81@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 25, 2014 at 03:40:28PM +0000, David Laight wrote:
> From: Guenter Roeck
> > Actually turns out one can use __attribute_const__, and it is
> > 
> > 	static inline int __attribute_const__ cpu_corepower_flags(void)
> > 
> > which turns out to be widely used.
> > 
> > I'll change that and resubmit after testing.
> 
> You don't need to tell the compiler that for an inline function.
I didn't check for the functions in question here, but in general your
statement is wrong.

For example:

static inline unsigned int __attribute_const__ read_cpuid_id(void)
{
	return readl(BASEADDR_V7M_SCB + V7M_SCB_CPUID);
}

from arch/arm/include/asm/cputype.h. The V7M_SCB_CPUID register never
changes, but there is no way gcc can deduce that.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
