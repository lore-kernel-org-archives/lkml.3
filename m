Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaHUODy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:03:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34580 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbaHUODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:03:53 -0400
Date: Thu, 21 Aug 2014 15:03:47 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH v4 2/3] usb: dwc3: dwc3-st: Add st-dwc3 devicetree
 bindings documentation
Message-ID: <20140821140347.GA21073@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-3-git-send-email-peter.griffin@linaro.org>
 <20140820180005.GU24500@saruman.home>
 <20140821133340.GC17487@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140821135620.GD9608@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821135620.GD9608@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, 21 Aug 2014, Felipe Balbi wrote:

> > Currently (in the vendor tree) one of the phys lives in
> > drivers/usb/phy and the other in drivers/phy.
> > I believe that is because one is only a usb phy and the other is a
> > multi function phy which can drive PCI-E or USB3.
> 
> right, but for mainline, we can have both PHYs in drivers/phy only.

Ah ok, I didn't know that, so thanks for that info.
> 
> > So to make that work, when dwc3/core.c gets the PHYS in
> > dwc3_core_get_phy() we need to use the different bindings.
> > 
> > I think we are the only platform using "one of each", but luckily
> > dwc3_core_get_phy() has been written generically enough that it "just
> > works" :-).
> 
> true, but I want to drop support for the legacy drivers/usb/phy layer
> from dwc3. I'll try to move all PHYs to drivers/phy for v3.18.

Ok, so for the next re-spin I will change this to just use the generic phy binding
for both usb2 & usb3 phys.

In parallel I will also migrate over the drivers/usb/phy driver to be just a generic phy
before I attempt to upstream it.

regards,

Peter



