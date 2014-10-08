Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaJHBcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:32:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:19331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbaJHBcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,674,1406617200"; 
   d="scan'208";a="602057080"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Topic: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Index: AQHP28Q4Z8Oqj7luBkykxkjhubrehJwldq+A
Date: Wed, 8 Oct 2014 01:32:09 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E997C63@SHSMSX101.ccr.corp.intel.com>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
	 <1412000548-9908-3-git-send-email-alvin.chen@intel.com>
 <1411981378.11022.1.camel@linux.intel.com>
In-Reply-To: <1411981378.11022.1.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s981WSsq021548

> > The SPI memory mapped I/O registers supported by Quark are different
> > from the current implementation, and Quark only supports the registers
> > of 'SSCR0', 'SSCR1', 'SSSR', 'SSDR', and 'DDS_RATE'. This patch is to
> > enable the SPI for Intel Quark X1000.
> >
> > This piece of work is derived from Dan O'Donovan's initial work for
> > Intel Quark
> > X1000 SPI enabling.
> 
> Minor comments are below.
> 
> After addressing them
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
OK.
> > +	case QUARK_X1000_SSP:
> > +		return RX_THRESH_QUARK_X1000_DFLT;
> >  	default:
> >  		return RX_THRESH_DFLT;
> >  	}
> > +
> 
> Redundant empty line.
> 
OK. I will remove it.

> >  static void pxa2xx_spi_clear_rx_thre(const struct driver_data *drv_data,
> > -				     u32 *sccr1_reg)
> > +					  u32 *sccr1_reg)
> 
> Unnecessary change.
> 
Improve it in the first patch.
> >  static void pxa2xx_spi_set_rx_thre(const struct driver_data *drv_data,
> > -				   u32 *sccr1_reg, u32 threshold)
> > +					u32 *sccr1_reg, u32 threshold)
> 
> Ditto.
> 
> Or you may do that in the first patch.
> 
Improve it in the first patch.
> >
> >  			pxa2xx_spi_set_rx_thre(drv_data, &sccr1_reg,
> > -					       rx_thre);
> > +						    rx_thre);
> 
> Ditto.
> 
Improve it in the first patch.
> > +	if (is_quark_x1000_ssp(drv_data) &&
> > +	    (read_DDS_RATE(reg) != chip->dds_rate))
> 
> Could it be one line?
> 
No, it is beyond 80 characters if it is in one line.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
