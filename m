Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaIMK7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:59:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59294 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbaIMK7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 06:59:19 -0400
Date: Sat, 13 Sep 2014 12:59:14 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Josh Wu <josh.wu@atmel.com>, Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5] mtd: nand: atmel_nand: retrieve NFC clock
Message-ID: <20140913105914.GD26281@piout.net>
References: <1410564239-8411-1-git-send-email-alexandre.belloni@free-electrons.com>
 <CAAEAJfD_Kujcf7m9RAbRrjA82A08N81rVwy6sXY_PORdrH0VkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAEAJfD_Kujcf7m9RAbRrjA82A08N81rVwy6sXY_PORdrH0VkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13/09/2014 at 10:26:18 +0100, Ezequiel Garcia wrote :
> > +       nfc->clk = devm_clk_get(&pdev->dev, NULL);
> > +       if (!IS_ERR(nfc->clk)) {
> > +               ret = clk_prepare_enable(nfc->clk);
> > +               if (ret)
> > +                       return ret;
> > +       } else {
> > +               dev_warn(&pdev->dev, "NFC clock missing, update your Device Tree");
> 
> Looks much better now thanks. If the clock is not really optional, you
> can consider this a firmware bug. We've used FW_BUG messages for these
> cases
> (see vim drivers/watchdog/orion_wdt.c), so you could write something like:
> 
> dev_warn(..., FW_BUG "devicetree clock missing");
> 

Yeah, I've considered using FW_WARN like Thomas suggested but I'm not
sure it really relates to device tree. Apart from x86, FW_WARN and
FW_BUG are only used on mvebu stuff ;)


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
