Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaKQOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:52:53 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:59741 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaKQOwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:52:51 -0500
MIME-Version: 1.0
In-Reply-To: <3480616.V2TMJFc7uE@wuerfel>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <50587083.ieLlCR4VrM@wuerfel> <CAJiQ=7C-HniwXiVrqQg3cnFNNYGwoxHJf8JP-XYOqM1yWoyXaw@mail.gmail.com>
 <3480616.V2TMJFc7uE@wuerfel>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 17 Nov 2014 15:52:15 +0100
Message-ID: <CAOiHx=ky5T7z3T3gX382d=3sw+gGUEfnwXwpcLGa_Oi5YyBwgw@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, dtor@chromium.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> I still think this is different in the sense that ARM multiplatform
> support is about combining platforms from separate mach-* directories,
> while your approach was to rewrite multiple mach-* directories into
> a single new one that remains separate from the others. While this is
> a great improvement, it doesn't get you any closer to having a
> combined BMIPS+RALINK+JZ4740+ATH79 kernel for instance. I don't know
> if such a kernel is something that anybody wants, or if it's even
> technically possible.
>
> If you wanted to do that however, starting with BMIPS you'd have
> to make it possible to define a new platform without the
> arch/mips/include/asm/mach-bmips/ directory (this should be possible
> already, so the hardest part is done), replace all global function
> calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
> platform-independent implementations or wrappers around per-platform
> callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
> outside of the "System type" choice statement.
> Until you do that, your platform isn't "more multipliplatform" than
> the others really, it just abstracts the differences between some
> SoCs nicer than most.

I guess a big blocker for such a real mips multiplatform kernel is
that there is still no defined (standard) interface for passing a
device tree to the kernel from the bootlader on mips, unlike on arm
(at least I'm not aware of any). And unless there is one, having a
multiplatform kernel does not make much sense, as there is no sane way
to tell apart different platforms on boot. But maybe we should just
define a way, and require new platforms to use it ;-)


Jonas
