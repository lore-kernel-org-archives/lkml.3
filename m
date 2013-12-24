Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab3LXCOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:14:42 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:52826 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817Ab3LXCOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:14:39 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "vpalatin@chromium.org" <vpalatin@chromium.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] regulator: act8865: add PMIC act8865 driver
Thread-Topic: [PATCH v4 1/3] regulator: act8865: add PMIC act8865 driver
Thread-Index: AQHO/5+AcLh0C42y9UK/gFJEdJHErZphJwcAgAF0goA=
Date: Tue, 24 Dec 2013 02:14:32 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172F2EA7F@penmbx01>
References: <1387776268-23036-1-git-send-email-wenyou.yang@atmel.com>
 <1387776328-23079-1-git-send-email-wenyou.yang@atmel.com>
 <20131223115746.GR30815@sirena.org.uk>
In-Reply-To: <20131223115746.GR30815@sirena.org.uk>
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



> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, December 23, 2013 7:58 PM
> To: Yang, Wenyou
> Cc: lgirdwood@gmail.com; linux-kernel@vger.kernel.org;
> grant.likely@linaro.org; rob.herring@calxeda.com; linux-
> doc@vger.kernel.org; vpalatin@chromium.org; Ferre, Nicolas;
> plagnioj@jcrosoft.com; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH v4 1/3] regulator: act8865: add PMIC act8865 driver
> 
> On Mon, Dec 23, 2013 at 01:25:28PM +0800, Wenyou Yang wrote:
> 
> > +static int act8865_set_suspend_voltage(struct regulator_dev *rdev,
> > +int uV) {
> > +	u32	selector;
> > +
> > +	selector = regulator_map_voltage_iterate(rdev, uV, uV);
> > +
> > +	return regulator_set_voltage_sel_regmap(rdev, selector); }
> 
> This looks wrong - it's going to set the normal voltage register that is
> set for runtime voltage changes.  The suspend operations are only for
> setting separate voltage registers, many PMICs know about system suspend
> and provide separate settings for that.  If this one doesn't then it
> shouldn't implement this operation.
I re-read the act8865 datasheet, There is NO a separate voltage registers for the suspend operation.
So I will remove this operation.

Thanks.

Best Regards,
Wenyou Yang
