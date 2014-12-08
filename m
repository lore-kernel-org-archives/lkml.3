Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaLHTrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:47:05 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:33866 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaLHTrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:47:03 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yunzhi Li <lyz@rock-chips.com>, "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "ulrich.prinz@googlemail.com" <ulrich.prinz@googlemail.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support for
 dwc2 usb controler platform driver.
Thread-Topic: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support
 for dwc2 usb controler platform driver.
Thread-Index: AQHQEIqcG5EhzbPG0kaiAXphivO/SpyBV0kAgAREGYCAAHzuoA==
Date: Mon, 8 Dec 2014 19:46:51 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484500279@US01WEMBX2.internal.synopsys.com>
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
 <1417783941-2418-4-git-send-email-lyz@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844FFB50@US01WEMBX2.internal.synopsys.com>
 <548521D1.2060509@rock-chips.com>
In-Reply-To: <548521D1.2060509@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Yunzhi Li [mailto:lyz@rock-chips.com]
> Sent: Sunday, December 07, 2014 7:58 PM
> 
> On 2014/12/6 3:04, Paul Zimmerman wrote:
> >> From: Yunzhi Li [mailto:lyz@rock-chips.com]
> >> Sent: Friday, December 05, 2014 4:52 AM
> >>
> >> Get PHY parameters from devicetree and power off usb PHY during
> >> system suspend.
> >>
> >> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> >> ---
> >>
> >>   drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
> >>   drivers/usb/dwc2/platform.c | 34 ++++++++++++++++++++++++++++++++++
> >>   2 files changed, 46 insertions(+), 21 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> >> index 200168e..2601c61 100644
> >> --- a/drivers/usb/dwc2/gadget.c
> >> +++ b/drivers/usb/dwc2/gadget.c
> >> [...]
> >>
> >>   	/*
> >> -	 * Attempt to find a generic PHY, then look for an old style
> >> -	 * USB PHY, finally fall back to pdata
> >> +	 * If platform probe couldn't find a generic PHY or an old style
> >> +	 * USB PHY, fall back to pdata
> >>   	 */
> >> -	phy = devm_phy_get(dev, "usb2-phy");
> >> -	if (IS_ERR(phy)) {
> >> -		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> >> -		if (IS_ERR(uphy)) {
> >> -			/* Fallback for pdata */
> >> -			plat = dev_get_platdata(dev);
> >> -			if (!plat) {
> >> -				dev_err(dev,
> >> -				"no platform data or transceiver defined\n");
> >> -				return -EPROBE_DEFER;
> >> -			}
> >> -			hsotg->plat = plat;
> >> -		} else
> >> -			hsotg->uphy = uphy;
> >> -	} else {
> >> -		hsotg->phy = phy;
> >> +	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
> >> +		plat = dev_get_platdata(dev);
> >> +		if (!plat) {
> >> +			dev_err(dev,
> >> +			"no platform data or transceiver defined\n");
> >> +			return -EPROBE_DEFER;
> >> +		}
> >> +		hsotg->plat = plat;
> >> +	} else if (hsotg->phy) {
> > You have changed the behavior here. Previously, the driver would work
> > even if there were no phys or pdata defined. Now it will return
> > -EPROBE_DEFER instead. Are you sure that won't break any existing
> > platforms?
> >
> I don't really catch your meaning. Could you please point out where is
> the difference? Thanks .

Yeah, sorry, I misread the patch. I think your new version is fine.

-- 
Paul

