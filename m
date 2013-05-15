Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3EOWyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:54:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3EOWys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:54:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Thu, 16 May 2013 00:54:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux-kernel@vger.kernel.org
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201305151516.52389.arnd@arndb.de> <20130515133237.GK18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130515133237.GK18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160054.21064.arnd@arndb.de>
X-Provags-ID: V02:K0:NODFj9poG3cKXHs+s0QFhIOo8vPyz3zz/uQ6ZCBAyMu
 IExrly8rYsV77RvSpFpATij8CfbjX6p5Ktr6pWgIQcCorTBMWD
 8X+pBMpnfa4reVqchzCM9b8pyJhiCQ0iz1+gp4P8nZZbIDGoWH
 ksSnfclOZqa1nHbiS/keMXGYPWjcYsgNTwodjiRCwCIscMw7zm
 UsLBJsgNyUXB6H3jf0FHe1S/432lhxO0BeN0XE/7KZk/sBvQaR
 lVAtwNAthbidcadWZwR9eyiMpS4OBrX8ujYBrhGP0/u5ayc9Qq
 UQwgFaN239bpJodVvBfZWSBWO/mNoRQjupPe7K1aa7b2dr+/ki
 PVbFQZ+7ouJ7vhqRvcsI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 May 2013, Russell King - ARM Linux wrote:
> Actually, that's probably the whole point of this - to do nothing.
> This changes the behaviour of the idle loop from using the WFI to
> just spinning instead with no wait-for-interrupt or anything else.
> We just keep reading the need_resched flag.
> 
> That's much better than the commented out code which opens a mighty
> big race condition which will then give bad scheduling behaviour,
> allowing the idle task to sleep in WFI until the next interrupt while
> the need_resched flag may be set.
> 
> Sure, there's better ways to do this, via the disable_hlt() stuff,
> and whatever its replacement implementation is now called.  But
> ultimately this workaround really is about "doing nothing" when
> idle!

Ah, I see. I also read the mach-gemini version of the idle code,
which is apparently the same thing as the code that was commented
out here, so that has the wakeup race.

Since it seems that WFI is broken on all fa526 cores, or at least
all the ones we want to support in Linux, maybe it's better to
not call WFI at all there?

	Arnd
