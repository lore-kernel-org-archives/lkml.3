Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3GFVAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 17:00:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:48904 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3GFVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 17:00:39 -0400
Date: Sat, 6 Jul 2013 23:00:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ulrich Prinz <ulrich.prinz@googlemail.com>
cc: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 9/9] clocksource: dw_apb_timer: special variant for
 rockchip rk3188 timers
In-Reply-To: <51D87E04.3060704@googlemail.com>
Message-ID: <alpine.DEB.2.02.1307062233480.32106@ionos.tec.linutronix.de>
References: <201307060051.09716.heiko@sntech.de> <201307060056.29370.heiko@sntech.de> <alpine.DEB.2.02.1307060153110.32106@ionos.tec.linutronix.de> <51D87E04.3060704@googlemail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

On Sat, 6 Jul 2013, Ulrich Prinz wrote:

> I got the message. With modifying the existing driver to support more
> function pointers in its system struct and assigning them at the
> beginning, and using them on runtime, these quirks are obsolete.

Correct.
 
> Again, this is the first time I provide code to the kernel officially

No problem. That's what code review is about. First post or not.

> and I learned from others that I should try it by modifying not too much
> code if not needed.
> 
> Adding more function pointers to a system relevant structure, doubling
> the number of functions and such didn't look non-invasive to me.

Well, it always depends. If there is a single place to deal with some
oddball hardware, a flag is often the simplest way to go.

If you have to add 10 conditionals in several functions then in a
first step converting the existing implementation into function
pointer calls and then in the next step providing new implementations
for your hardware is most of the time simpler and cleaner.

> But, I totally agree with your argumentation and I even wanted to do it
> in the way you explained in your replies. Just the courage was missing I
> guess :)

Gut feelings are often a better guidance than our self-doubting
intellect. :)

But don't worry. I had to learn it the hard way as well and I still
trip over from time to time.

Thanks,

	tglx
