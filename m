Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaCJKNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:13:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:26106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaCJKNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,622,1389772800"; 
   d="scan'208";a="495371308"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] i2c: designware-pci: add 10-bit addressing mode
 functionality for BYT I2C
Thread-Topic: [PATCH 1/2] i2c: designware-pci: add 10-bit addressing mode
 functionality for BYT I2C
Thread-Index: AQHPO3UbiIlLD/Gj10moMvszm8QZo5raGeow
Date: Mon, 10 Mar 2014 10:12:44 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0155D56E@PGSMSX103.gar.corp.intel.com>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-2-git-send-email-chiau.ee.chew@intel.com>
 <20140309085357.GA4695@katana>
In-Reply-To: <20140309085357.GA4695@katana>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Sunday, March 09, 2014 4:54 PM
> To: Chew, Chiau Ee
> Cc: Mika Westerberg; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] i2c: designware-pci: add 10-bit addressing mode
> functionality for BYT I2C
> 
> On Fri, Mar 07, 2014 at 10:12:50PM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> >
> > All the I2C controllers on Intel BayTrail LPSS subsystem able to
> > support 10-bit addressing mode functionality.
> >
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > Signed-off-by: Ong, Boon Leong <boon.leong.ong@intel.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-pcidrv.c |   17 +++++++++++------
> >  1 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c
> > b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > index f1dabee..87f2fc4 100644
> > --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > @@ -64,12 +64,19 @@ struct dw_pci_controller {
> >  	u32 tx_fifo_depth;
> >  	u32 rx_fifo_depth;
> >  	u32 clk_khz;
> > +	u32 functionality;
> >  };
> >
> >  #define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |
> 	\
> >  				DW_IC_CON_SLAVE_DISABLE |	\
> >  				DW_IC_CON_RESTART_EN)
> >
> > +#define DW_DEFAULT_FUNCTIONALITY (I2C_FUNC_I2C |
> 	\
> > +					I2C_FUNC_SMBUS_BYTE |
> 	\
> > +					I2C_FUNC_SMBUS_BYTE_DATA |
> 	\
> > +					I2C_FUNC_SMBUS_WORD_DATA |
> 	\
> > +					I2C_FUNC_SMBUS_I2C_BLOCK)
> 
> Can't we have I2C_FUNC_SMBUS_EMUL here? (Need checking with
> I2C_SMBUS_QUICK)

Per my understanding, this I2C host is not able to support I2C_SMBUS_QUICK.

