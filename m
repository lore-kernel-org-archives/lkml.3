Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3EPJAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:00:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51426 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3EPI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:59:54 -0400
Date: Thu, 16 May 2013 09:57:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Message-ID: <20130516085711.GP18614@n2100.arm.linux.org.uk>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201305151516.52389.arnd@arndb.de> <20130515133237.GK18614@n2100.arm.linux.org.uk> <201305160054.21064.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305160054.21064.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:54:20AM +0200, Arnd Bergmann wrote:
> Ah, I see. I also read the mach-gemini version of the idle code,
> which is apparently the same thing as the code that was commented
> out here, so that has the wakeup race.
> 
> Since it seems that WFI is broken on all fa526 cores, or at least
> all the ones we want to support in Linux, maybe it's better to
> not call WFI at all there?

Well, if its a CPU core thing, then it's even easier - the proc-*.S
file can handle it just fine (because that's where the WFI code is.)
Just delete the contents of the processor specific idle function, IOW:

/*
 * cpu_fa526_do_idle()
 */
        .align  4
ENTRY(cpu_fa526_do_idle)
        mcr     p15, 0, r0, c7, c0, 4           @ Wait for interrupt
        mov     pc, lr

remove the WFI from there.
