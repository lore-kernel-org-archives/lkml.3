Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3AWNAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:00:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47063 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3AWNAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:00:38 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 12/12] video: da8xx-fb: set upstream clock rate (if
 reqd)
Thread-Topic: [PATCH v2 12/12] video: da8xx-fb: set upstream clock rate (if
 reqd)
Thread-Index: AQHN8yZ0aX5R/OgrX0CoCyC6ZfFxsphKKIUAgADiQgCAC9noIA==
Date: Wed, 23 Jan 2013 13:00:20 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA9123E@DBDE01.ent.ti.com>
References: <cover.1358251447.git.afzal@ti.com>
 <26e787b021cda89a080f80657c2094b9ff2decaf.1358251448.git.afzal@ti.com>
 <20130115153222.23734.7924@quantum> <50F63452.1060004@ti.com>
In-Reply-To: <50F63452.1060004@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0ND0hAb003821

Hi Mike,

On Wed, Jan 16, 2013 at 10:32:10, Nori, Sekhar wrote:
> On 1/15/2013 9:02 PM, Mike Turquette wrote:
> > Quoting Afzal Mohammed (2013-01-15 05:44:36)

> >> Note:
> >> A better (if allowable) solution may be to represent clock divider in
> >> LCDC IP as a basic divider clock - the one defined in common clock
> >> framework. But for this to happen, all the platform's using this driver
> >> should be using common clock framework (DaVinci is yet to be converted
> >> to use common clock framework). And it has to be determined whether
> >> common clock framework allows this kind of a clock modelling inside a
> >> driver and for this to be part of clock tree. Advantage of doing so
> >> would be better resolution for pixel clock, even though without this
> >> existing use cases are working properly. Or another extreme alternative
> >> would be to replicate clk-divider of common clock framework inside the
> >> driver, but that probably is not preferred and not worth as it would be
> >> duplication and without much advantage to existing users.

> > Modeling the divider inside your IP block as a clock is supported in the
> > common clock framework.  Linking up these sorts of clocks to the clock
> > tree was one of the original design goals of CCF.

> > Regarding DaVinci: converting that platform over to use CCF would be the
> > best approach.

> This is work in progress. There are patches that have been posted. Work
> has been slow on this though due to lack of bandwidth.

> > An alternative would be that you could break
> > single-image boot for AM335x and DaVinci, by having AM335x use CCF and
> > DaVinci use the legacy clock framework.  From the LCDC driver's

> Single image for DaVinci and AM335x is not possible anyway since ARMv5
> and ARMv6+ cannot be supported in a single image.

> > perspective this should not matter and is indeed the purpose of the
> > clk.h api and clkdev interfaces, however looking at this driver I can
> > see there would still be a lot ifdef-ery going on... better to just
> > convert everything over to CCF.

> Waiting for DaVinci CCF to complete will be too long a wait. Probably
> convert to CCF just for AM335x ATM. There would be some ifdef'ry but
> hopefully that need not be inside function bodies. Would have to see the
> implementation, I guess.

v4 posted has the divider in LCDC IP modeled by clock node for CCF, for
non-CCF (DaVinci), existing logic is kept as is with the help of ifdef's
(as DaVinci maintainer mentioned that DaVinci CCF may take some time)

Regards
Afzal


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
