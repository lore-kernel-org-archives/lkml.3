Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaKGQtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:49:12 -0500
Received: from gloria.sntech.de ([95.129.55.99]:58568 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaKGQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:49:10 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: rockchip: add pinctrl nodes for SPDIF, LCDC, CIF, HDMI, USB and GPS
Date: Fri, 07 Nov 2014 17:52:23 +0100
Message-ID: <5384745.1WqprI8GVl@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1415373589-11650-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1415373589-11650-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Freitag, 7. November 2014, 16:19:49 schrieb Julien CHAUVEAU:
> On RK3066, add pinctrl nodes for SPDIF, LCDC1, CIF0/1, HDMI and USB.
> On RK3188, add pinctrl nodes for SPDIF, LCDC1, CIF and GPS.

Please don't bulk-add pinctrl settings nobody is using for the forseeable 
future. There are currently no spdif, lcdc, cif and hdmi drivers for those 
socs and things like the usb_vbus and sd_pwr pins are used as gpios through 
regulators.

Pinctrl settings can be added in the same patch adding the device node, 
_after_ a driver got accepted.


> At the same time, add some missing pinctrl for SDMMC0 and SDMMC1
> and fix the unit addresses of GPIO0 and GPIO1 banks in rk3188.dtsi.

I you're concatenating change descriptions by "and" or your "At the same 
time", it's a good indicator that these should be two separate patches.
The general rule is, one patch - one issue.


So I'd suggest resending the address fix for the two gpios and leaving the pin 
settings be till something really uses them,


Heiko

