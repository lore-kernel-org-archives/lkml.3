Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3JBUPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:15:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40327 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JBUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:15:50 -0400
Date: Wed, 2 Oct 2013 21:13:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: cinifr <cinifr@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, coosty@163.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
	support for Allwinner A20(sunxi 7i).
Message-ID: <20131002201350.GS12758@n2100.arm.linux.org.uk>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com> <1379852488-32147-2-git-send-email-cinifr@gmail.com> <20130923181707.GR2779@lukather> <CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com> <20130925184435.GH2954@lukather> <CAK3cCBwOpkk5ObeEm+by=RS6jSptPdGZM+fvpgGZpX9TPij5gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK3cCBwOpkk5ObeEm+by=RS6jSptPdGZM+fvpgGZpX9TPij5gg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 09:48:11PM +0800, cinifr wrote:
> Hi  Maxime,
>     I have test it, but I found it does not work. If using
> smp_prepare_cpus, the kernenl cannot find the secondary cpus because
> that smp_prepare_cpus semms not be excuted before kernel is booting
> secondary cpus. So I have to use early_initcall.

Please don't do this - you're hacking around what could be a real problem.
Instead, please investigate what is going on and why your smp_prepare_cpus()
function never gets called.

Quite honestly, whenever I see crap like the above, it just makes me want
to tell the ARM-SoC people to forever /dev/null your emails because you
really don't know how to deal with the Linux kernel.

Always *fully* investigate a problem that you find to determine whether
it's your problem or some as yet undiscovered kernel bug.  Never hack
around it and then submit a patch suggesting that your workaround is
something that "has" to be done.
