Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaFYOub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:50:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43310 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:50:30 -0400
Date: Wed, 25 Jun 2014 16:49:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] sched: Fix compiler warnings
Message-ID: <20140625144955.GP14781@pengutronix.de>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
 <20140625071416.GM14781@pengutronix.de>
 <53AADC63.8080106@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53AADC63.8080106@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guenter,

On Wed, Jun 25, 2014 at 07:27:47AM -0700, Guenter Roeck wrote:
> >Maybe the author's intention was:
> >
> >	static inline int cpu_corepower_flags(void) __attribute__((const));
> >
> >?
> >This specifies that the function has no side effects and the return value
> >only depends on the (here non-existing) function arguments.
> >
> 
> Possibly, but either I am missing something or this doesn't compile.
You need to do a separate declaration:

	static inline int cpu_corepower_flags(void) __attribute__((const));
	static inline int cpu_corepower_flags(void)
	{
		...

Does this help?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
