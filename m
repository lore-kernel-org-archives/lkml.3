Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3CCMH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:07:59 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55754 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3CCMHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:07:54 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 7/7] spi: spi-fsl-spi: Add support for gpio chipselects for GRLIB type cores
To: Anton Vorontsov <anton@enomsg.org>, Andreas Larsson <andreas@gaisler.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <20130207160821.GA22224@lizard.gateway.2wire.net>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com> <1360242731-13700-8-git-send-email-andreas@gaisler.com> <20130207160821.GA22224@lizard.gateway.2wire.net>
Date: Sat, 02 Mar 2013 21:34:47 +0000
Message-Id: <20130302213447.2478B3E2249@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 08:08:21 -0800, Anton Vorontsov <anton@enomsg.org> wrote:
> On Thu, Feb 07, 2013 at 02:12:11PM +0100, Andreas Larsson wrote:
> > This relies upon of_spi_register_master to find out which gpios to use.
> > 
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> > ---
> >  drivers/spi/spi-fsl-lib.h |    1 +
> >  drivers/spi/spi-fsl-spi.c |   53 +++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 48 insertions(+), 6 deletions(-)
> 
> Just a couple of minor nits...
> 
> > diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
> > index d5c788b..52db693 100644
> > --- a/drivers/spi/spi-fsl-lib.h
> > +++ b/drivers/spi/spi-fsl-lib.h
> > @@ -71,6 +71,7 @@ struct mpc8xxx_spi {
> >  
> >  #ifdef CONFIG_SPI_FSL_SPI
> >  	int type;
> > +	int native_chipselects;
> >  	u8 max_bits_per_word;
> >  
> >  	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
> > diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> > index 55652e6..2befe16 100644
> > --- a/drivers/spi/spi-fsl-spi.c
> > +++ b/drivers/spi/spi-fsl-spi.c
> > @@ -418,7 +418,7 @@ static int fsl_spi_setup(struct spi_device *spi)
> >  {
> >  	struct mpc8xxx_spi *mpc8xxx_spi;
> >  	struct fsl_spi_reg *reg_base;
> > -	int retval;
> > +	int retval, desel;
> 
> We don't usually place variable declarations on the same line, unless the
> variables are closely related.

That's not something I've ever heard before. I certainly won't reject a
patch over it.

g.

