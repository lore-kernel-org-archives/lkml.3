Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3A1JSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:18:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37189 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3A1JSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:18:17 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>
Subject: RE: RE: RE: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Thread-Topic: RE: RE: [PATCH v2 1/2] clk: divider: prepare for minimum
 divider
Thread-Index: AQHN+V5a5bjFaLjo3UCX0TyVDxkD+ZhXFbKAgAE2ShCAAA9iAIABh5HwgABmqACABCQvYA==
Date: Mon, 28 Jan 2013 09:18:08 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA943FA@DBDE01.ent.ti.com>
References: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
 <20130123214053.9205.49804@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ABC@DBDE01.ent.ti.com>
 <20130124170630.10623.78749@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA93851@DBDE01.ent.ti.com>
 <20130125223524.10623.29375@quantum>
In-Reply-To: <20130125223524.10623.29375@quantum>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0S9IKfW000409

Hi Mike,

On Sat, Jan 26, 2013 at 04:05:24, Mike Turquette wrote:

> Thank you for the information.  In short, the way you program your clock
> depend on the configuration of your lcdc device.
> 
> As such I am not sure the basic divider is the right choice for you.
> You might be better off creating a clock for your IP which takes into
> account these details.  Luckily it is possible to inherit from the basic
> clock types and create a new type.
> 
> An example of this is the MXS divider.  It uses the basic divider as a
> "parent class" and adds a busy bit.  This is a better approach than
> putting every feature into the basic divider type.  You can see how it
> was done in drivers/clk/mxs/clk-div.c
> 
> Let me know what you think.

Yes, a derived divider is better.

As mentioned in other thread, the modeling of clock nodes (derived plus
gates) would bring in considerable (relative to complete driver) code, the
advantage being higher pixel clock resolution. Current use cases work
as per existing divider setting in driver. Hence now it seems a better
decision now is to proceed with logic as in v2 (not using clock nodes).
And later depending on the use case requirement, clock tree modeling can
be implemented.

Thanks for your input.

Regards
Afzal


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
