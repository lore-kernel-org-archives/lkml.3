Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaIZHV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:21:27 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64595 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaIZHVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:21:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, balbi@ti.com
Cc: thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com,
        Peter Chen <peter.chen@freescale.com>, p.zabel@pengutronix.de,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Fri, 26 Sep 2014 09:20:54 +0200
Message-ID: <3346642.tZaefcZubX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926003934.GD12770@saruman>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <20140926003750.GA12770@saruman> <20140926003934.GD12770@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CMCYH81ptgAUDIraPCi2tWPB0tcAYeW6KFYTnotdGUJ
 c+gQ1wwyjaXg5Px0p0pK3hodDMbqCbkzp2sCu653TLuutbPZ8S
 NwTMiZp++PAo+b5edEM8IUJ1/Vj26DsOCY2Qbyc4p4fKZYh1Tg
 2MGdhRftYG88On8tYqqTMjQl1u/lXBmmI/Z1mQgZkNx8Ix2SEQ
 vZTD+fsGrvSRuvFLfSLf3P6ero6SyHvftC1A11+cTmFxvwfJsq
 uC/bCdjLZ4u1srS9c/ZqEOjoaLjzWy3DPsPQelCn8K2Av0ycvS
 8TQfVafBbnX8+4TE4Yx+wx2q9vBGDrddsk79YEoTCJ0BKCpWAM
 Pd4nkZpOGKwGx/ADSmtk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 19:39:34 Felipe Balbi wrote:
> > 
> > why would a glue layer need to access registers from the core ? That
> > sounds very odd. I haven't seen that and will, definitely, NACK such a
> > patch 
> > 
> > can you further describe why you think a glue layer might need to access
> > core IP's registers ?
> 
> I just realised we're talking about chipidea here... in any case, it's
> still valid to ask why would glue need to fiddle with core IP's
> registers.

Generally, the glue driver wouldn't access the registers, but I don't
think it's important to prevent it from doing that. In some cases, 
a glue driver needs to override a function of the core driver, e.g.
to work around an errata. We have a lot of those quirks in ATA drivers,
one example from ahci_mvebu.c is

static void ahci_mvebu_regret_option(struct ahci_host_priv *hpriv)
{
        /*
         * Enable the regret bit to allow the SATA unit to regret a
         * request that didn't receive an acknowlegde and avoid a
         * deadlock
         */
        writel(0x4, hpriv->mmio + AHCI_VENDOR_SPECIFIC_0_ADDR);
        writel(0x80, hpriv->mmio + AHCI_VENDOR_SPECIFIC_0_DATA);
}

	Arnd
