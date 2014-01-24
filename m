Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaAXOJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:09:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53971 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaAXOJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:09:44 -0500
Message-ID: <52E27408.8060808@ti.com>
Date: Fri, 24 Jan 2014 19:39:12 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <george.cherian@ti.com>, <heikki.krogerus@linux.intel.com>,
        <rogerq@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1390299099-14764-1-git-send-email-kishon@ti.com> <20140121144725.GF30451@saruman.home>
In-Reply-To: <20140121144725.GF30451@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 21 January 2014 08:17 PM, Felipe Balbi wrote:
> On Tue, Jan 21, 2014 at 03:41:38PM +0530, Kishon Vijay Abraham I wrote:
>> Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs),
>> do not return from probe if the USB PHY library returns -ENODEV as that
> 
> this isn't correct, they all have PHYs, some of them might not be
> controllable.

right, but we use USB PHY library only for controllable PHYs (apart from using
nop).
> 
>> indicates the platform does not have PHY.
> 
> not really, that indicates the current platform tried to grab a PHY and
> the PHY doesn't exist. If there's anybody with a non-controllable PHY
> and someone gives me a really good reason for not using the generic
> no-op PHY, then we should add a flag and we could:
> 
> 	if (!likely(dwc->flags & DWC3_USB2PHY_DRIVER_NOT_NEEDED))
> 		dwc3_grab_phys(dwc);
> 
> But I really want to see the argument against using no-op. As far as I
> could see, everybody needs a PHY driver one way or another, some
> platforms just haven't sent any PHY driver upstream and have their own
> hacked up solution to avoid using the PHY layer.

I was trying to address Heikki concerns in my previous version [1] where I used
quirks to identify if the platform does not have PHY.

[1] -> https://lkml.org/lkml/2013/12/5/32

Thanks
Kishon
