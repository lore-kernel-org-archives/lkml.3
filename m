Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3FDJx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:53:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3FDJxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:53:54 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "khilman@linaro.org" <khilman@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: RE: [PATCH 05/11] spi: omap2-mcspi: enhance pinctrl support
Thread-Topic: [PATCH 05/11] spi: omap2-mcspi: enhance pinctrl support
Thread-Index: AQHOXeczwOifcgHON0C7EqilqXbQOJkgui0AgASclOA=
Date: Tue, 4 Jun 2013 09:53:04 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC22370@DBDE04.ent.ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
 <1369995191-20855-6-git-send-email-gururaja.hebbar@ti.com>
 <20130601192726.GS16790@sirena.org.uk>
In-Reply-To: <20130601192726.GS16790@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 00:57:26, Mark Brown wrote:
> On Fri, May 31, 2013 at 03:43:05PM +0530, Hebbar Gururaja wrote:
> > Amend the spi omap controller to optionally take a pin control
> > handle and set the state of the pins to:
> > 
> > - "default" on boot, resume and before performing an spi transfer
> > - "idle" after initial default, after resume default, and after each
> > spi xfer
> > - "sleep" on suspend()
> 
> Looking at this code I can't really see what's OMAP-specific about it -
> exactly the same flow should apply to pretty much any SPI controller,
> especially given that the code will happily ignore missing states.
> We're just setting the idle state when not actively transferring data
> which seems sensible and generic.
> 
> This suggests to me that we should be adding this code into the core,
> probably joined up with the transfer_one_message stuff, so that any
> hardware which has an idle state will be able to get the benefit.  Can
> anyone think of a reason why we shouldn't do that?

Let me pull out some info about these and come back

> 


Regards, 
Gururaja
