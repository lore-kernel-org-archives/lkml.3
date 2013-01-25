Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3AYMGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:06:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44344 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab3AYMGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:06:52 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>
Subject: RE: RE: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Thread-Topic: RE: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Thread-Index: AQHN+V5a5bjFaLjo3UCX0TyVDxkD+ZhXFbKAgAE2ShCAAA9iAIABh5Hw
Date: Fri, 25 Jan 2013 12:06:41 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA93851@DBDE01.ent.ti.com>
References: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
 <20130123214053.9205.49804@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ABC@DBDE01.ent.ti.com>
 <20130124170630.10623.78749@quantum>
In-Reply-To: <20130124170630.10623.78749@quantum>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PC6qgI020192

Hi Mike,

On Thu, Jan 24, 2013 at 22:36:30, Mike Turquette wrote:
> Quoting Mohammed, Afzal (2013-01-24 03:29:15)

> > It is a functional constraint: divider has 8 bits and it can have
> > all possible values (0 to 255) and divider value corresponds to
> > value set in the 8 bits. But depending on the modes the minimum
> > value that can be configured (to get display working) varies.
> > Eg. For raster mode (which the driver is presently supporting), it
> > can take a minimum value of 2, while in LIDD (LCD interface display
> > driver) mode it can take a min value of 1.
> > 
> > Here min rate is not a constraint w.r.t divider in LCDC IP, but
> > rather min divider.

> Just so I understand correctly... you are saying that the functional
> constraint is not caused by the clock rate, but instead by the divider
> value?  For the different modes (raster vs LIDD) is the clock rate the
> same, or is the clock rate different?

> What is the clock output rate of the divider in raster mode?  What is
> the clock output rate of the divider in LIDD mode?

Yes, functional constraint in caused by divider value.

clock output rate can defined for both modes as follows,

p_clk (clock output rate) = lcd_clk (input clock rate) / div,

to configure "div", we have r/w 8 bits, so div values can
range from 0-255,

And IP spec says value "0" and "1" should not be written, in
raster mode. Further it says if in LIDD mode it can have values
from 0-255, but effect of writing "0" is same as "1".

Effect of divider value on output rate is in the same way for
both modes as per above expression (except for writing "0" in
LIDD mode).

The driver supports only raster mode.

Regards
Afzal

Note: link to trm has been mentioned in the earlier reply.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
