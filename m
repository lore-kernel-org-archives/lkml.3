Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaFYPlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:41:12 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60061 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756909AbaFYPlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:41:11 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Guenter Roeck'" <linux@roeck-us.net>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "Vincent Guittot" <vincent.guittot@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] sched: Fix compiler warnings
Thread-Topic: [PATCH v2] sched: Fix compiler warnings
Thread-Index: AQHPkIa1Qh6RlHX42kq1WmxtMU9WYJuB9lcg
Date: Wed, 25 Jun 2014 15:40:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17265D81@AcuExch.aculab.com>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
 <20140625071416.GM14781@pengutronix.de> <53AADC63.8080106@roeck-us.net>
 <20140625144955.GP14781@pengutronix.de> <53AAE4D2.5020104@roeck-us.net>
In-Reply-To: <53AAE4D2.5020104@roeck-us.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5PFfHHY009502

From: Guenter Roeck
> On 06/25/2014 07:49 AM, Uwe Kleine-Knig wrote:
> > Hello Guenter,
> >
> > On Wed, Jun 25, 2014 at 07:27:47AM -0700, Guenter Roeck wrote:
> >>> Maybe the author's intention was:
> >>>
> >>> 	static inline int cpu_corepower_flags(void) __attribute__((const));
> >>>
> >>> ?
> >>> This specifies that the function has no side effects and the return value
> >>> only depends on the (here non-existing) function arguments.
> >>>
> >>
> >> Possibly, but either I am missing something or this doesn't compile.
> > You need to do a separate declaration:
> >
> > 	static inline int cpu_corepower_flags(void) __attribute__((const));
> > 	static inline int cpu_corepower_flags(void)
> > 	{
> > 		...
> 
> Actually turns out one can use __attribute_const__, and it is
> 
> 	static inline int __attribute_const__ cpu_corepower_flags(void)
> 
> which turns out to be widely used.
> 
> I'll change that and resubmit after testing.

You don't need to tell the compiler that for an inline function.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
