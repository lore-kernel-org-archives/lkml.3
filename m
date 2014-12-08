Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLHNXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:23:21 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:48858 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbaLHNXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:23:17 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-2.tower-39.messagelabs.com!1418044989!19748594!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Hartmut Knaack <knaack.h@gmx.de>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joe Perches" <joe@perches.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v4 3/8] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH v4 3/8] iio: Add support for DA9150 GPADC
Thread-Index: AQHQCN0xZCxTBnRxIkiXMfyjciLtmJyAGvIAgAWnQdA=
Date: Mon, 8 Dec 2014 13:23:07 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB52290B@SW-EX-MBX01.diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
 <377be6cf23ba23dac0b21fe2a449307ec5bac63a.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
 <5480E7F4.7090808@gmx.de>
In-Reply-To: <5480E7F4.7090808@gmx.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB8DNSKB025509

On December 04, 2014 23:02, Hartmut Knaack wrote:

> > +	indio_dev = devm_iio_device_alloc(&pdev->dev,
> > +					  sizeof(struct da9150_gpadc));
> BTW: If you use sizeof(*gpadc) instead (like it is usually done as well),
> it will perfectly fit in one line.

I preferred to be explicit that the item is a struct, but really not that fussed
either way. Also have been asked previously in a separate driver to make the
same mod you mention so will update accordingly.

> > +	ret = devm_request_threaded_irq(dev, irq, NULL, da9150_gpadc_irq,
> > +					IRQF_ONESHOT, "GPADC", gpadc);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to request IRQ %d: %d\n", irq, ret);
> > +		goto iio_map_unreg;
> You need to return ret here, no jump to error out path.

Yes, thanks. Annoyed I missed that in the re-factor. Will fix it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
