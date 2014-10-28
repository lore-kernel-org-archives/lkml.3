Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaJ1IwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:52:13 -0400
Received: from down.free-electrons.com ([37.187.137.238]:58930 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015AbaJ1IwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:52:07 -0400
Date: Tue, 28 Oct 2014 09:52:03 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
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
Message-ID: <20141028085202.GC722@piout.net>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20141028085053.41c6ce46@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028085053.41c6ce46@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28/10/2014 at 08:50:53 +0100, Boris Brezillon wrote :
> Hi,
> 
> On Tue, 28 Oct 2014 00:09:29 +0100
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > This series removes the mach/ headers dependency from the reset driver. It is
> > also laying some groundwork for the necessary power management support rework.
> > 
> > The first patch adds and export a function to shutdown the sdram from the sdramc
> > driver. That function also take the RSTC CR register and a value as parameters
> > to be able to reset the chip. This is a hackish way of doing it but it ensures
> > that all the code fits in one cache line. We already have plan to start using
> > the sram to have a cleaner way to execute that code safely as soon as that
> > series goes in:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198778.html
> > 
> > The second patch makes the sdramc driver usable from the board files.
> > 
> > The third patch actually registers the sdramc driver from the boards files.
> > The fourth patch does the same, only for sam9g45 and sam9rl to simplify future
> > merging as the board files have been removed. Simply drop that patch.
> > 
> > The fifth patch makes the at91-reset driver use the newly created
> > at91_ramc_shutdown() function and removes the mach/ headers inclusion.
> 
> I'm not a big fan of this approach.
> 
> I definitely think each step of the reset process should be handled in
> the appropriate block (and the patch series you pointed out would
> definitely help in achieving this goal), but you're just moving all the
> stuff done in the reset driver into the SDRAM one, which means you're
> solving one design issue by introducing a new one.
> 
> Moreover, the errata at the origin of this hack is attached to the RSTC
> (Rest Controller) block in the datasheets.
> 

I agree it is still not clean but it is a step in the good direction.
The sdram shutdown will have to be down in the sdram driver at some
point, even if the errata is attached to the reset controller. At least,
the series introduces a function to do the sdram shutdown.

> I'd rather keep the reset driver as is and move SDRAM related macros
> into a specific header (include/linux/memory/atmel-sdram.h or
> include/soc/atmel/memory.h as you proposed) so that the reset driver
> can reference them without including mach headers.
> 

My personal opinion is that it is better to hide the registers/bits from
the reset driver right now as we have two different IPs and the sdram
driver already knows how to make the difference between them.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
