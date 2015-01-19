Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbbASO34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:29:56 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:37550 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbbASO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:29:55 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2015 09:29:54 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-15.tower-39.messagelabs.com!1421677381!27723493!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Mark Rutland" <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@linaro.org>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: RE: [PATCH V1] mfd: da9063: Add device tree support
Thread-Topic: [PATCH V1] mfd: da9063: Add device tree support
Thread-Index: AQHQMAfIRQ9Taq9op0KhnMfi9yaqmZzHO76AgAAv/sA=
Date: Mon, 19 Jan 2015 14:22:59 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B52C08@SW-EX-MBX02.diasemi.com>
References: <201501141438.t0EEcMBg010491@swsrvapps-01.diasemi.com>
 <20150119095423.GM21886@x1>
In-Reply-To: <20150119095423.GM21886@x1>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0JEU2x5004074

On 19 January 2015 09:54, Lee Jones wrote:

> On Wed, 14 Jan 2015, Steve Twiss wrote:
> > From: Steve Twiss <stwiss.opensource@diasemi.com>
> >
> > ---
> > Checks performed with linux-next/v3.19-rc4/scripts/checkpatch.pl
> >  da9063.txt                total: 0 errors, 0 warnings, 94 lines checked
> >  da9063-core.c             total: 0 errors, 0 warnings, 192 lines checked
> >  da9063-i2c.c              total: 0 errors, 0 warnings, 277 lines checked
> >  core.h                    total: 0 errors, 0 warnings, 99 lines checked
> 
> There is no need to put this in here really.  It is assumed that
> checkpatch.pl has been run and that no warnings/errors exists.
> 

ok -- I will remove this in future

[...]

> > +Required properties:
> > +
> > +- compatible : Should be "dlg,da9063-ca", "dlg,da9063-bb" or/and
> > +  "dlg,da9063-ad".
> 
> What are 'ca', 'bb' and 'ad'?

There are multiple variants of the DA9063 chip -- historical support.
The AD chip has a different register map to BB and CA  silicon and the
variant information is read from the chip at run-time and used to set
up the correct regmap_config tables during initialisation.

[...]

> > +++ b/drivers/mfd/da9063-core.c
> > @@ -85,6 +85,7 @@ static const struct mfd_cell da9063_devs[] = {
> >  		.name		= DA9063_DRVNAME_LEDS,
> >  	},
> >  	{
> > +		.of_compatible = "dlg,da9063-watchdog",
> 
> Can you put the of_compatible attribute at the end of the structure
> please?
> 
> >  		.name		= DA9063_DRVNAME_WATCHDOG,
> >  	},
> >  	{
> > @@ -98,6 +99,7 @@ static const struct mfd_cell da9063_devs[] = {
> >  		.resources	= da9063_onkey_resources,
> >  	},
> >  	{
> > +		.of_compatible = "dlg,da9063-rtc",
> 
> Same here.

Sure.

[...]
> >
> > +static const struct of_device_id da9063_dt_ids[] = {
> > +	{ .compatible = "dlg,da9063-ad", },
> > +	{ .compatible = "dlg,da9063-bb", },
> > +	{ .compatible = "dlg,da9063-ca", },
> 
> Why is there a need to differientiae between 'ad', 'bb' and 'ca'
> (whatever they are)?

As described above.

> > +	{ /* sentinel */ }
> 
> Nit: You can drop this comment.

ok.

[...]

I will also make changes to separate into multiple patches
as described in https://lkml.org/lkml/2015/1/19/149
Will re-send as patch V2 ...

Regards,
Steve

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
