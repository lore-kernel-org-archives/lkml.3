Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaDXHZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:25:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33502 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaDXHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:25:49 -0400
Date: Thu, 24 Apr 2014 09:25:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
In-Reply-To: <CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404240918110.4704@ionos.tec.linutronix.de>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com> <534B4C6D.5070003@linux.intel.com> <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com> <5357A594.6050404@linux.intel.com>
 <CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Linus Walleij wrote:
> However this is a first time for an embedded irqchip (coupled
> with GPIO ACPI) creeping into the x86 world, so it needs some
> attention I think, do we have a direction forward for peaceful
> coexistence of several irq controllers picking some IRQ
> numbers/descriptors dynamically as they probe, also on
> x86 systems?

The issue on x86 is, that we have basically two classes of interrupts.

 - The hardwired ones (in the chipset and we have no way to
   change that except with MSI)

 - The dynamic ones, i.e. MSI[X]

So for allocating the MSI interrupts we use the range above the
possible hardwired interrupts.

Unfortunaly the information where the reserved/hardwired range ends is
not available to drivers, but it should be simple to do so.

I'm traveling until friday, so please wait before you commit that
fugly hack. I'll have a closer look how we can handle that at the core
level.

Thanks,

	tglx


