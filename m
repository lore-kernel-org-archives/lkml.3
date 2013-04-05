Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161628Ab3DEFwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:52:33 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:52641 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161162Ab3DEFwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:52:31 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4] gpio: mcp23s08: convert driver to DT
Date: Fri, 5 Apr 2013 07:51:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spi mailing list <spi-devel-general@lists.sourceforge.net>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1365069722-15408-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdZdOabqWHo9j+Kq_MHWFEaj9=+d8vBxLtH6OZbBX3vGJw@mail.gmail.com>
In-Reply-To: <CACRpkdZdOabqWHo9j+Kq_MHWFEaj9=+d8vBxLtH6OZbBX3vGJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304050751.02172.larsi@wh2.tu-dresden.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013 15:44:08 Linus Walleij wrote:
> On Thu, Apr 4, 2013 at 12:02 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> 
wrote:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > This converts the mcp23s08 driver to be able to be used with device
> > tree.
> > There is a "spi-present-mask" device tree property, that allows to
> > use multiple of this spi chips on the same chipselect.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > v4:
> > - removed the ability to specify the pullup from device tree
> > - updated binding doc
> 
> (...)
> 
> > @@ -668,6 +742,7 @@ static struct spi_driver mcp23s08_driver = {
> > 
> >         .driver = {
> >         
> >                 .name   = "mcp23s08",
> >                 .owner  = THIS_MODULE,
> > 
> > +               .of_match_table = of_match_ptr(mcp23s08_spi_of_match),
> 
> Will this compile if CONFIG_OF is not enabled?

Yes, of_match_ptr(blah) after preprocessing gets NULL then.

Regards,
Lars
