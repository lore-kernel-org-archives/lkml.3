Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3BEUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:44:40 -0500
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:56434 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756109Ab3BEUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:44:35 -0500
Date: Tue, 5 Feb 2013 21:06:49 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org,
        richard.genoud@gmail.com, JM.Lin@atmel.com, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [v4 PATCH 00/12] atmel spi controller with dmaengine and
 device tree support
Message-ID: <20130205200649.GD30595@game.jcrosoft.org>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <20130205141410.712493E1265@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205141410.712493E1265@localhost>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7410954663441050396
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:14 Tue 05 Feb     , Grant Likely wrote:
> On Mon, 14 Jan 2013 15:34:25 +0800, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> > Hi All, 
> > 
> > This set of patches is to add dmaengine and device tree support for atmel spi.
> > The work is based on Nicolas and Richard's work.
> > It is tested on at91sam9x5ek, at91sam9m10g45ek, at91sam9263ek and at91sam9g20ek.
> > 
> > It is based on v3.8-rc3.
> 
> Hi Wenyou,
> 
> The patches look fine on a quick look, but I cannot apply them without a
> Signed-off-by line from you since you are the person posting the
> patches. Please read section 12 of Documentation/SubmittingPatches
> (about line #288) and then reply confirming what your signed-off-by line
> should be.

grant if it's ok with you I prefer this go via arm-soc

Best Regards,
J.
> 
> > 
> > Changelog:
> > v4:
> > 	1./ Take Joe Perches's advance, rewrite atmel_spi_is_v2(struct atmel_spi *as)
> > 	     and atmel_spi_use_dma(struct atmel_spi *as),
> > 	     and remove atmel_spi_use_pdc(struct atmel_spi *as).
> > 
> > 	2./ Rebase on v3.8-rc3.
> > 
> > V3:
> > 	1./ Rebase on v3.8-rc2.
> > 
> > 	2./ Remove some Jean-Christophe's patches which has been
> > 	    applied on v3.8-rc2.
> > 
> > 	3./ Remove spi property "cs-gpios" from the SoC dtsi files
> > 	    to the board dts files to avoid some useless pin conflicts.
> > 
> > v2: 
> >    	1./ Remove the patch :PATCH]mtd: m25p80: change the m25p80_read to reading page to page
> > 	    which purpose to fix the BUG: when run "flashcp /bin/busybox /dev/mtdX" in 
> > 	    the at91sam9g25ek with DMA mode, it arises a OOPS. 
> > 	    Now fix it in this patch:
> > 	    [PATHC] spi/atmel_spi: add dmaengine support changing to fix the [BUG].
> > 
> > 	2./ Remove two patches:
> >    	    which purpose to read dts property to select SPI IP version and DMA mode
> > 	    Now they will be gat from device tree different compatile.
> > 
> > 	3./ Fix DMA: when enable both spi0 AND spi1, the spi0 doesn't work BUG.
> > 
> > 	4./ Rebase v3.7-rc8.
> > 
> > Best Regards,
> > Wenyou Yang.
> > 
> > Nicolas Ferre (5):
> >   spi/atmel_spi: add physical base address
> >   spi/atmel_spi: call unmapping on transfers buffers
> >   spi/atmel_spi: status information passed through controller data
> >   spi/atmel_spi: add flag to controller data for lock operations
> >   spi/atmel_spi: add dmaengine support
> > 
> > Richard Genoud (6):
> >   spi/atmel_spi: fix spi-atmel driver to adapt to slave_config changes
> >   spi/atmel_spi: correct 16 bits transfers using PIO
> >   spi/atmel_spi: correct 16 bits transfer with DMA
> >   ARM: at91: add clocks for spi dt entries
> >   ARM: dts: add spi nodes for atmel SoC
> >   ARM: dts: add spi nodes for the atmel boards
> > 
> > Wenyou Yang (1):
> >   spi/atmel_spi: update the dt support
> > 
> >  arch/arm/boot/dts/at91sam9260.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9263.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9263ek.dts         |   14 +
> >  arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   14 +
> >  arch/arm/boot/dts/at91sam9g45.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9m10g45ek.dts      |   14 +
> >  arch/arm/boot/dts/at91sam9n12.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9n12ek.dts         |   14 +
> >  arch/arm/boot/dts/at91sam9x5.dtsi           |   18 +
> >  arch/arm/boot/dts/at91sam9x5ek.dtsi         |   14 +
> >  arch/arm/mach-at91/at91sam9260.c            |    2 +
> >  arch/arm/mach-at91/at91sam9g45.c            |    2 +
> >  arch/arm/mach-at91/at91sam9n12.c            |    2 +
> >  arch/arm/mach-at91/at91sam9x5.c             |    2 +
> >  drivers/spi/spi-atmel.c                     |  809 ++++++++++++++++++++++++---
> >  15 files changed, 908 insertions(+), 69 deletions(-)
> > 
> > -- 
> > 1.7.9.5
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> -- 
> Grant Likely, B.Sc, P.Eng.
> Secret Lab Technologies, Ltd.
