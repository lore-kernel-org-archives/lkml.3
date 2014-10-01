Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaJAPEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:04:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaJAPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:04:22 -0400
Date: Wed, 1 Oct 2014 17:04:19 +0200
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
Message-ID: <20141001150418.GA14609@amd>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
 <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
 <20141001133527.GA12750@amd>
 <alpine.DEB.2.10.1410010915440.2332@shineypoop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410010915440.2332@shineypoop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> > > +			     rst_manager_base_addr + 0x10);
> > 
> > Would it be possible to copy reset manager description struct from
> > u-boot and use it here, instead of raw offset?
> 
> I will replace this 0x10 with a macro that reflects how the register is 
> named in the register map.

That would be better than 0x10, but even better would be just copying

struct socfpga_reset_manager {
        u32     status;
        u32     ctrl;
        u32     counts;
        u32     padding1;
        u32     mpu_mod_reset;
        u32     per_mod_reset;
        u32     per2_mod_reset;
        u32     brg_mod_reset;
};

from u-boot. Unlike macros, structs have advantages that typos lead to
easier-to-see failure modes... (And they are easier to read/parse,
too).

Thanks,
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
