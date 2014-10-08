Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaJHArT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:47:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:55039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaJHArR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:47:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,674,1406617200"; 
   d="scan'208";a="611094224"
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
Subject: RE: [PATCH 1/2 v2] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
Thread-Topic: [PATCH 1/2 v2] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
Thread-Index: AQHP28Kzrtwa1R6LgUKlE/qxsg2Y55wlapFg
Date: Wed, 8 Oct 2014 00:46:58 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E997C28@SHSMSX101.ccr.corp.intel.com>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
	 <1412000548-9908-2-git-send-email-alvin.chen@intel.com>
 <1411980737.10697.0.camel@linux.intel.com>
In-Reply-To: <1411980737.10697.0.camel@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s980lOxO021443


> I'm okay with the current version, though I have few minor comments below.
> 
> > Introduce helper functions to access the 'SSCR0' and 'SSCR1'.
> >
> 
> Like you said in the summary there are many accessors to many registers, not
> only cr1/cr0. Perhaps, you may extend your commit message.
> 
OK.

> In any case
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
OK.
> > +
> >  /*
> >   * Read and write LPSS SSP private registers. Caller must first check that
> >   * is_lpss_ssp() returns true before these can be called.
> > @@ -234,7 +301,7 @@ static int null_writer(struct driver_data *drv_data)
> >  	void __iomem *reg = drv_data->ioaddr;
> >  	u8 n_bytes = drv_data->n_bytes;
> >
> > -	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
> > +	if (pxa2xx_spi_txfifo_full(drv_data)
> >  		|| (drv_data->tx == drv_data->tx_end))
> 
> Just wondering if those two could fit one line.
> 
No, if make the two in one line, it is 84 characters.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
