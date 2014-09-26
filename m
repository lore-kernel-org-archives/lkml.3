Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaIZNC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:02:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33850 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbaIZNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:02:25 -0400
Date: Fri, 26 Sep 2014 15:02:22 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #2
Message-ID: <20140926130222.GA4408@piout.net>
References: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
 <201409261250.02565.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409261250.02565.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/09/2014 at 12:50:02 +0200, Arnd Bergmann wrote :
> On Monday 22 September 2014, Nicolas Ferre wrote:
> 
> > Nicolas Ferre (4):
> >       ARM: at91: introduce basic SAMA5D4 support
> >       ARM: at91: SAMA5D4 SoC detection code and low level routines
> 
> This resulted in build failures both in at91x40_defconfig and some
> randconfigs with MMU disabled. I've applied the patch below on top
> to fix it.
> 
> I'm not exactly happy about the soc detection code anyway after I
> had to look at that. Why do you even hardcode the physical register
> location rather than getting it from DT?
> 
> Also, why do you care about which SoC version you have for the
> modern SAMA5 chips? All I see is a sama5d4_map_io() callback
> that maps a lot of completely unused registers along with
> the uart that you normally get from the implicit debug_ll_io_init,
> and the SRAM that should probably be turned into a normal driver.
> 

Yeah, there are upcoming patches that add more differences between
sama5d3 and sama5d4. Also, a huge cleanup is planned after all the
boards files have been removed and all the boards have been either
migrated to DT and CCF or dropped.

I'll owe you the drink of your choice if that is not done by 3.20 ;)

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
