Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3AON7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:59:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60865 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab3AON7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:59:42 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Nori, Sekhar" <nsekhar@ti.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 08/10] video: da8xx-fb: obtain fb_videomode info from dt
Thread-Topic: [PATCH 08/10] video: da8xx-fb: obtain fb_videomode info from dt
Thread-Index: AQHN6olgYao2ec3g5EedwyKq/6QVMZg9PLCAgABdw5CADN+xEA==
Date: Tue, 15 Jan 2013 13:59:03 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA85B05@DBDE01.ent.ti.com>
References: <cover.1357304090.git.afzal@ti.com>
 <78e026555731e0bbe8475610279d3e5265d124b9.1357304090.git.afzal@ti.com>
 <20130107091131.GC23478@pengutronix.de>
 <C8443D0743D26F4388EA172BF4E2A7A93EA7FC7A@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA7FC7A@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0FDxm1d009202

Hi Steffen,

On Mon, Jan 07, 2013 at 14:51:15, Mohammed, Afzal wrote:
> On Mon, Jan 07, 2013 at 14:41:31, Steffen Trumtrar wrote:
> > On Mon, Jan 07, 2013 at 10:41:30AM +0530, Afzal Mohammed wrote:

> > > +- display-timings: list of different videomodes supported by the lcd
> > > +  panel, represented as childs, can have multiple modes supported, if
> > > +  only one, then it is considered native mode, if multiple modes are
> > > +  provided, native mode can be set explicitly, more details available
> > > +  @Documentation/devicetree/bindings/video/display-timing.txt
> 
> > Keep in mind that the text combined with...
> 
> > > +		if (of_get_fb_videomode(np, lcdc_info, 0)) {
> > > +			dev_err(&dev->dev, "timings not available in DT\n");
> > > +			return NULL;
> > > +		}
> > > +		return lcdc_info;
> > > +	}
> > 
> > ... this is not correct. You are just supporting the first display-timings
> > subnode (of_get_fb_videomode(..., 0)).
> 
> 
> Yes right, I will modify the text to reflect what the driver does.

Thinking about it further, it seems the right thing to do
in this case would be to invoke as,

"of_get_fb_videomode(np, lcd_info, OF_USE_NATIVE_MODE)".

Updated version has been posted to the lists (forgot to cc you)

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
