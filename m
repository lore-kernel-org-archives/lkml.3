Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab3E2GyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 02:54:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58105 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab3E2GyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 02:54:13 -0400
From: "Cherian, George" <george.cherian@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH 3/3] usb: dwc3: omap Modify dwc3_omap_readl/writel with
 offsets
Thread-Topic: [PATCH 3/3] usb: dwc3: omap Modify dwc3_omap_readl/writel with
 offsets
Thread-Index: AQHOWrC098qakCArf0OG9E8offgmMpkaVxiAgAFl4MA=
Date: Wed, 29 May 2013 06:54:04 +0000
Message-ID: <BD228B1E3C6D7740B44C214F9AEEACE335F454@DBDE04.ent.ti.com>
References: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
 <1369641777-4509-4-git-send-email-george.cherian@ti.com>
 <20130528173215.GB15794@arwen.pp.htv.fi>
In-Reply-To: <20130528173215.GB15794@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Balbi, Felipe
> Sent: Tuesday, May 28, 2013 11:02 PM
> To: Cherian, George
> Cc: Balbi, Felipe; linux-usb@vger.kernel.org; linux-omap@vger.kernel.org;
> linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org
> Subject: Re: [PATCH 3/3] usb: dwc3: omap Modify dwc3_omap_readl/writel
> with offsets
> 
> Hi,
> 
> On Mon, May 27, 2013 at 01:32:57PM +0530, George Cherian wrote:
> > This patch modifies dwc3_omap_readl/writel calls to accomodate
> > both OMAP5 and AM437x reg maps (It uses the cached register offsets).
> > Also renames OMAP5 IRQ1 as IRQMISC, IRQ1 bits as IRQMISC bits.
> >
> > Signed-off-by: George Cherian <george.cherian@ti.com>
> 
> can you change this patch a bit so that it adds wrappers around
> dwc3_omap_*() ? The idea is the have the code look like:
> 
> static u32 dwc3_omap_read_utmi_status(struct dwc3_omap *omap)
> {
> 	return dwc3_omap_readl(omap->base,
> USBOTGSS_UTMI_OTG_STATUS +
> 			omap->utmi_otg_offset);
> }
> 
> (likewise for write and for all other offsets, of course)
> 
> that way, reading/writing to registers which need the offset will be
> less error-prone and th driver will look a little nicer.

Yes , I will do it in next version.
> 
> --
> Balbi
-George
