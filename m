Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaCDRUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:20:30 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48500 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbaCDRU0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:20:26 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Tue, 4 Mar 2014 09:20:17 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        Harini Katakam <harinik@xilinx.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] i2c: Add driver for Cadence I2C controller
References: <1393632046-20062-1-git-send-email-soren.brinkmann@xilinx.com>
 <8af0e222-6337-4ec4-b718-099a9decc5ec@TX2EHSMHS034.ehs.local>
 <20140304170401.GA18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140304170401.GA18529@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <a6082008-e1c8-45cd-9bd0-6727dd087633@TX2EHSMHS041.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, 2014-03-04 at 11:04AM -0600, Josh Cartwright wrote:
> On Fri, Feb 28, 2014 at 07:06:29PM -0800, S?ren Brinkmann wrote:
> > On Fri, 2014-02-28 at 04:00PM -0800, Soren Brinkmann wrote:
> > > Add a driver for the Cadence I2C controller. This controller is for
> > > example found in Xilinx Zynq.
> > > 
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > >  .../devicetree/bindings/i2c/i2c-cadence.txt        |  21 +
> > >  MAINTAINERS                                        |   1 +
> > >  drivers/i2c/busses/Kconfig                         |   7 +
> > >  drivers/i2c/busses/Makefile                        |   1 +
> > >  drivers/i2c/busses/i2c-cadence.c                   | 901 +++++++++++++++++++++
> > >  5 files changed, 931 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> > >  create mode 100644 drivers/i2c/busses/i2c-cadence.c
> > > 
> > [...]
> > > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > > index f5ed03164d86..7806c1654068 100644
> > > --- a/drivers/i2c/busses/Kconfig
> > > +++ b/drivers/i2c/busses/Kconfig
> > > @@ -375,6 +375,13 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
> > >  	help
> > >  	  The unit of the TWI clock is kHz.
> > >  
> > > +config I2C_CADENCE
> > > +	tristate "Cadence I2C Controller"
> > > +	depends on ARCH_ZYNQ
> > This can be reduced to a dependency on COMMON_CLK only, I think.
> 
> Do you really need to depend on COMMON_CLK?  Most of the clk_* API's are
> properly stubbed when !HAVE_CLK.
I do. clk_register_notifier() is only available with COMMON_CLK.
Alternatively those #ifdefs could go into the driver, but that wouldn't
look nice :)

There is v2 on the list already, let's move the discussion there.

	Sören


