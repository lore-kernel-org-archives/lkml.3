Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbbATNXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:23:43 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:21077 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519AbbATNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:23:41 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-180.messagelabs.com!1421760204!41928012!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        DT <devicetree@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, "Pawel Moll" <pawel.moll@arm.com>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: RE: [PATCH V2 1/2] mfd: da9063: Add device tree support
Thread-Topic: [PATCH V2 1/2] mfd: da9063: Add device tree support
Thread-Index: AQHQNAY/P+aw9292NEy5C38h4IQM85zI1G8AgAAAJQA=
Date: Tue, 20 Jan 2015 13:23:23 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B52DA5@SW-EX-MBX02.diasemi.com>
References: <cover.1421684991.git.stwiss.opensource@diasemi.com>
 <d765ef11de06a4ac5721ecf3283ba1333a6d0c8c.1421684991.git.stwiss.opensource@diasemi.com>
 <20150120104544.GS5767@x1>
In-Reply-To: <20150120104544.GS5767@x1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KDNmeH012216


On 20 January 2015 10:46 Lee Jones wrote:

[...]

> >  static const struct regmap_range da9063_ad_readable_ranges[] = {
> >  	{
> >  		.range_min = DA9063_REG_PAGE_CON,
> > @@ -203,6 +206,13 @@ static struct regmap_config da9063_regmap_config
> = {
> >  	.cache_type = REGCACHE_RBTREE,
> >  };
> >
> > +static const struct of_device_id da9063_dt_ids[] = {
> > +	{ .compatible = "dlg,da9063-ad", },
> > +	{ .compatible = "dlg,da9063-bb", },
> > +	{ .compatible = "dlg,da9063-ca", },
> 
> I'm still a bit bemused as to why these require their own compatible
> strings?  They are never matched (of_match_device()) on and it appears
> they can be dynamically told apart by poking.
> 

Yes: like you said. Why bother with a 2-letter variant code in the DT if the
driver's behaviour is automatic?

It was a design style decision on my side. I was being explicit in my definitions 
and I added the 2-letter code to handle (potential) differences in the way
platform data can be handled in the driver. There is nothing right now, I was just
considering the future and the ABI.

However, I've talked myself round this argument several times -- I guess the
explicit compatibility letters in the devices tree are jarring against the automatic
detection inside the driver.

I will remove the 2-letter extensions from the next submission.

Regards,
Steve


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
