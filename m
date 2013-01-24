Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3AXL3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:29:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab3AXL32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:29:28 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>
Subject: RE: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Thread-Topic: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Thread-Index: AQHN+V5a5bjFaLjo3UCX0TyVDxkD+ZhXFbKAgAE2ShA=
Date: Thu, 24 Jan 2013 11:29:15 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA92ABC@DBDE01.ent.ti.com>
References: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
 <20130123214053.9205.49804@quantum>
In-Reply-To: <20130123214053.9205.49804@quantum>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0OBTa0n011129

Hi Mike,

On Thu, Jan 24, 2013 at 03:10:53, Mike Turquette wrote:
> Quoting Afzal Mohammed (2013-01-23 03:38:52)

> > Some of clocks can have a limit on minimum divider value that can be
> > programmed, prepare for such a support.

> > Add a new field min_div for the basic divider clock and a new dynamic
> > clock divider registration function where minimum divider value can
> > be specified. Keep behaviour of existing divider clock registration
> > functions, static initialization helpers as was earlier.

> My first question is whether the minimum divider you plan to use is an
> actual constraint of the hardware (e.g. the clock controller ip only
> lets program two bits which divide by 4, 5, 6 or 7, where 4 is the
> minimum divider) or if this is a functional constraint (e.g. the clock
> hardware can divide by a lower value, but you never want that since it
> results in non-functional video/audio/whatever).  If this is more of a
> functional constraint then perhaps a new api like clk_set_min_rate makes
> more sense.

It is a functional constraint: divider has 8 bits and it can have
all possible values (0 to 255) and divider value corresponds to
value set in the 8 bits. But depending on the modes the minimum
value that can be configured (to get display working) varies.
Eg. For raster mode (which the driver is presently supporting), it
can take a minimum value of 2, while in LIDD (LCD interface display
driver) mode it can take a min value of 1.

Here min rate is not a constraint w.r.t divider in LCDC IP, but
rather min divider.

As it is the case, you prefer a clk_divider_set_min_div()?

> 
> Secondly, have you looked into using the rate-table option provided by
> the basic divider clock?  Can you explain how this is not a good fit for
> your needs?  Perhaps there are too many divisor values so the table
> would be large?

Divider values can range from 2-255 (254 possible values), so I believe
it is not a suitable candidate here (also divider to values have 1-to-1
mapping)

Regards
Afzal


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
