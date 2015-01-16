Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbbAPKXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:23:33 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:49762 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbbAPKXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:23:30 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v3 2/3] dt-bindings: Add pinctrl bindings for
 mt65xx/mt81xx.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, <dandan.he@mediatek.com>,
        <alan.cheng@mediatek.com>, <toby.liu@mediatek.com>
In-Reply-To: <CACRpkdYRrs2=gNM1XGSh1cSo5Pvx6iNLt4HjL6gdTqGPWYSRDw@mail.gmail.com>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
	 <CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
	 <20141127101830.GP30369@pengutronix.de>
	 <CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
	 <20141202135527.GM30369@pengutronix.de>
	 <CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
	 <20150112122200.GC18908@pengutronix.de>
	 <CACRpkdYXrdiRWMV8YpxrSLe2rLEV-ZnX7=36w21zGquh==6WgA@mail.gmail.com>
	 <20150113161614.GF23940@pengutronix.de>
	 <CACRpkdYRrs2=gNM1XGSh1cSo5Pvx6iNLt4HjL6gdTqGPWYSRDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2015 18:23:25 +0800
Message-ID: <1421403805.11671.58.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 10:53 +0100, Linus Walleij wrote:
> On Tue, Jan 13, 2015 at 5:16 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Tue, Jan 13, 2015 at 11:05:22AM +0100, Linus Walleij wrote:
> 
> >> > You often talk about ambiguities. Could you give an example what
> >> > ambiguities you mean?
> >>
> >> What happened was this pins = ; arguments were sometimes
> >> strings and sometimes integers, that becomes strange to handle
> >> in code, ambiguous.
> >
> > I see. I like naming it 'pinmux' because that's what it is: pins and
> > mux settings. A plain 'pinno' suggests that it contains only pin mubers,
> > without mux setting. How about 'pin-no-mux'? We also could add an
> > explicit "pins-are-numbered" property instead of distinguishing this
> > by property names.
> 
> I kind of like this "pins-are-numbered" thing.
> 
> The other property for the pin, whether pinmux or pin-no-mux or
> pin-num-and-mux etc is no such big deal, as long as it's
> consistent and documented with the generic bindings.

Hi Linus,

To make sure I understand it correct, you think something like this is
OK?

	pinctrl@01c20800 {
		compatible = "mediatek,mt8135-pinctrl";
[...]
		pins-are-numbered;

		i2c0_pins_a: i2c0@0 {
			pins1 {
				pins = <MT8135_PIN_100_SDA0__FUNC_SDA0>,
					<MT8135_PIN_101_SCL0__FUNC_SCL0>;
				bias-disable;
			};
		};
[....]
	}

Joe.C


