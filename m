Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbaJ1HvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:51:00 -0400
Received: from down.free-electrons.com ([37.187.137.238]:58254 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759774AbaJ1Hu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:50:57 -0400
Date: Tue, 28 Oct 2014 08:50:53 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: at91: Remove mach/ includes from the reset
 driver
Message-ID: <20141028085053.41c6ce46@bbrezillon>
In-Reply-To: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 28 Oct 2014 00:09:29 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> This series removes the mach/ headers dependency from the reset driver. It is
> also laying some groundwork for the necessary power management support rework.
> 
> The first patch adds and export a function to shutdown the sdram from the sdramc
> driver. That function also take the RSTC CR register and a value as parameters
> to be able to reset the chip. This is a hackish way of doing it but it ensures
> that all the code fits in one cache line. We already have plan to start using
> the sram to have a cleaner way to execute that code safely as soon as that
> series goes in:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198778.html
> 
> The second patch makes the sdramc driver usable from the board files.
> 
> The third patch actually registers the sdramc driver from the boards files.
> The fourth patch does the same, only for sam9g45 and sam9rl to simplify future
> merging as the board files have been removed. Simply drop that patch.
> 
> The fifth patch makes the at91-reset driver use the newly created
> at91_ramc_shutdown() function and removes the mach/ headers inclusion.

I'm not a big fan of this approach.

I definitely think each step of the reset process should be handled in
the appropriate block (and the patch series you pointed out would
definitely help in achieving this goal), but you're just moving all the
stuff done in the reset driver into the SDRAM one, which means you're
solving one design issue by introducing a new one.

Moreover, the errata at the origin of this hack is attached to the RSTC
(Rest Controller) block in the datasheets.

I'd rather keep the reset driver as is and move SDRAM related macros
into a specific header (include/linux/memory/atmel-sdram.h or
include/soc/atmel/memory.h as you proposed) so that the reset driver
can reference them without including mach headers.


Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
