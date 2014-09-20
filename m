Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaITIcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 04:32:12 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35363 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498AbaITIcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 04:32:10 -0400
Date: Sat, 20 Sep 2014 09:31:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        tony@atomide.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, drake@endlessm.com, loeliger@gmail.com,
        santosh.shilimkar@ti.com, linux-omap@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 4/7] ARM: l2c: Add support for overriding prefetch
	settings
Message-ID: <20140920083149.GI12379@n2100.arm.linux.org.uk>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com> <1409062680-15906-5-git-send-email-t.figa@samsung.com> <20140919095000.GF29620@piout.net> <20140919163932.GH12379@n2100.arm.linux.org.uk> <20140919183007.GG29620@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919183007.GG29620@piout.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:30:07PM +0200, Alexandre Belloni wrote:
> On 19/09/2014 at 17:39:32 +0100, Russell King - ARM Linux wrote :
> > On Fri, Sep 19, 2014 at 11:50:01AM +0200, Alexandre Belloni wrote:
> > > On 26/08/2014 at 16:17:57 +0200, Tomasz Figa wrote :
> > > > Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
> > > > settings configured in registers leading to crashes if L2C is enabled
> > > > without overriding them. This patch introduces bindings to enable
> > > > prefetch settings to be specified from DT and necessary support in the
> > > > driver.
> > > > 
> > > > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > > 
> > > Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > > 
> > > It is working and useful on Atmel's sama5d4 were the bootloader is not
> > > configuring the L2C prefetch. However, I'm wondering whether we should
> > > add support for setting L310_PREFETCH_CTRL_DATA_PREFETCH and
> > > L310_PREFETCH_CTRL_INSTR_PREFETCH. I'm currently doing it by using
> > > ".l2c_aux_val    = L310_AUX_CTRL_DATA_PREFETCH |
> > > L310_AUX_CTRL_INSTR_PREFETCH" (those are the same bits) but this has the
> > > disadvantage of displaying the "L2C: platform modifies aux control
> > > register:" twice.
> > 
> > The L2C documentation, freely available from the ARM infocentre website,
> > has the answer to this for you.
> > 
> > The two bits in the prefetch control register which control the data
> > and instruction prefetching are aliases of the aux control register.
> > If you set them to a value in one register, they are reflected in the
> > other.
> > 
> > The reason for that is that once the L2 cache is enabled, writes to
> > the aux control register are no longer permitted, but it's safe to
> > enable and disable the prefetching with the cache already enabled.
> > This reason is even stated in the documentation.
> > 
> 
> Yeah, so my question still holds, should we have an other way to
> enable/disable I/D prefetch by adding two other DT bindings ?

Your question doesn't hold, because the above answers it conclusively.
No.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
