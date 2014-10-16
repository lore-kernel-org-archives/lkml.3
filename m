Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaJPIMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:12:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:18884 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJPIMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:12:40 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] spi/atmel: add support for runtime PM
Thread-Topic: [PATCH] spi/atmel: add support for runtime PM
Thread-Index: AQHP6OOz3LvTFspzlkWsWVFQ1Yxkwpwxzh0AgACO95A=
Date: Thu, 16 Oct 2014 08:09:49 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF589DDC@penmbx02.corp.atmel.com>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
 <20141016073004.GL27755@sirena.org.uk>
In-Reply-To: <20141016073004.GL27755@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Thursday, October 16, 2014 3:30 PM
> To: Yang, Wenyou
> Cc: linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
> 
> On Thu, Oct 16, 2014 at 09:49:20AM +0800, Wenyou Yang wrote:
> 
> > +static int atmel_spi_runtime_resume(struct device *dev) {
> > +	struct spi_master *master = dev_get_drvdata(dev);
> > +	struct atmel_spi *as = spi_master_get_devdata(master);
> > +
> > +	pinctrl_pm_select_default_state(dev);
> > +	clk_prepare_enable(as->clk);
> > +
> 
> This looks mostly good but you should check the return value of
> clk_prepare_enable() - it can fail.
Thanks a lot, I will add it.

Best Regards,
Wenyou Yang
