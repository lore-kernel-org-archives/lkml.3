Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaICRnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:43:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48026 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877AbaICRns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:43:48 -0400
Date: Wed, 3 Sep 2014 19:43:44 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gael PORTAY <gael.portay@gmail.com>
Subject: Re: [PATCH 0/5] clk: at91: fix USB clk support on at91rm9200/sam9
 SoCs
Message-ID: <20140903194344.2099f2f3@bbrezillon>
In-Reply-To: <20140903172005.11368.11852@quantum>
References: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140902223846.5251.86384@quantum>
	<20140903100828.69cc79fe@bbrezillon>
	<20140903172005.11368.11852@quantum>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, 03 Sep 2014 10:20:05 -0700
Mike Turquette <mturquette@linaro.org> wrote:

> Quoting Boris BREZILLON (2014-09-03 01:08:28)
> > Hi Mike,
> > 
> > On Tue, 02 Sep 2014 15:38:46 -0700
> > Mike Turquette <mturquette@linaro.org> wrote:
> > 
> > > Quoting Boris BREZILLON (2014-09-02 00:50:13)
> > > > Hi,
> > > > 
> > > > This patch series fixes several bugs in the PLL driver preventing a proper
> > > > set_rate on the PLL clk.
> > > > It also enables propagation of set_rate request on the USB clk in order to
> > > > configure the PLL rate according to the USB block requirement (48 MHz).
> > > > 
> > > > Note that existing kernels, relying on the PLL configuration made by the
> > > > the bootloader should not be impacted by this bug, but others (those
> > > > directly booting from at91bootstrap or not enabling USB support in the
> > > > bootloader) will be.
> > > > 
> > > > This bug was reported by Gaël, who's directly booting the kernel from the
> > > > bootstrap.
> > > 
> > > Applied to clk-next.
> > 
> > Thanks for applying this series to clk-next, but I wonder if we
> > shouldn't try to get this merged in 3.17 (in order to avoid back-porting
> > these fixes to 3.17 stable branch).
> 
> These bug have been in there since 2013, so I guess you'll need to
> backport to any other stable branches as well?
> 
> > 
> > I know I said it shouldn't impact that much users, but IMHO we
> > shouldn't rely on this assumption.
> 
> Well, the bugs have existed since last year I guess, and they are not a
> new regression as such. In fact I think that these problems have existed
> since drivers/clk/at91/clk-pll.c and drivers/clk/at91/clk-usb.c were
> introduced, no?

Well, actually the code is here since the beginning, but it's only used
since 3.17: these fixes are touching at91sam9260/at91rm9200 specific
clks code, and these 2 families have been moved to the CCF in 3.17 (DT
node definitions and CCF Kconfig option selection for these SoCs).
I'm not sure we have to backport the fixes in this case.

> 
> > 
> > Let me know if you're okay to take these patches in clk-fixes, because
> > this patch [1] needs to be applied first (I guess Nicolas will take it
> > through his -fixes branch).
> 
> The dependency is another reason I am not thrilled about taking this
> through -fixes. But additionally, "rework rm9200 USB clock to propagate
> set_rate to the parent clk" is more like a new feature than a fix.

Kind of. But without this feature, USB IPs (both host and
device) won't work if the PLL is not correctly initialized by the
bootloader, so this can be considered as a bug fix.

> 
> I feel that the code here is a bit more than I usually like to take just
> for fixing a new regression, especially when this is neither a
> regression nor is it new.

I understand.

> 
> Let me know if you still disagree.

I'd certainly prefer not having to back port these "fixes" in 3.17 after
3.18 is out, but I can deal with it.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
