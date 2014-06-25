Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaFYQF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:05:28 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60729 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757510AbaFYQF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:05:26 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: =?Windows-1252?Q?=27Uwe_Kleine-K=F6nig=27?= 
	<u.kleine-koenig@pengutronix.de>
CC: "'Guenter Roeck'" <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dietmar Eggemann" <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, "Paul Mackerras" <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] sched: Fix compiler warnings
Thread-Topic: [PATCH v2] sched: Fix compiler warnings
Thread-Index: AQHPkIa1Qh6RlHX42kq1WmxtMU9WYJuB9lcg///y64CAABKcMA==
Date: Wed, 25 Jun 2014 16:04:43 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17265E10@AcuExch.aculab.com>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
 <20140625071416.GM14781@pengutronix.de> <53AADC63.8080106@roeck-us.net>
 <20140625144955.GP14781@pengutronix.de> <53AAE4D2.5020104@roeck-us.net>
 <063D6719AE5E284EB5DD2968C1650D6D17265D81@AcuExch.aculab.com>
 <20140625155259.GQ14781@pengutronix.de>
In-Reply-To: <20140625155259.GQ14781@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König 
> Hello,
> 
> On Wed, Jun 25, 2014 at 03:40:28PM +0000, David Laight wrote:
> > From: Guenter Roeck
> > > Actually turns out one can use __attribute_const__, and it is
> > >
> > > 	static inline int __attribute_const__ cpu_corepower_flags(void)
> > >
> > > which turns out to be widely used.
> > >
> > > I'll change that and resubmit after testing.
> >
> > You don't need to tell the compiler that for an inline function.
> I didn't check for the functions in question here, but in general your
> statement is wrong.
> 
> For example:
> 
> static inline unsigned int __attribute_const__ read_cpuid_id(void)
> {
> 	return readl(BASEADDR_V7M_SCB + V7M_SCB_CPUID);
> }
> 
> from arch/arm/include/asm/cputype.h. The V7M_SCB_CPUID register never
> changes, but there is no way gcc can deduce that.

Hmm... it all rather depends on the order of the optimisations and 
inlining.

I've tried to use 'restrict' on the parameters to an inline function
in an attempt to get 'noalias' - but the reverse inference never
seems to be applied.

	David



