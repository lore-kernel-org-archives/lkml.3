Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3LBQ3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:29:19 -0500
Received: from mx0.aculab.com ([213.249.233.131]:53838 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752725Ab3LBQ3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:29:17 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems on OMAP4 Panda
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 2 Dec 2013 16:28:09 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7455@saturn3.aculab.com>
In-Reply-To: <529C4726.6080708@ti.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems on OMAP4 Panda
Thread-Index: Ac7vOcf/vQunUOt2Q0+dzPLqwCG/pQAQUjBg
References: <1385730118-26402-1-git-send-email-rogerq@ti.com> <1385730118-26402-2-git-send-email-rogerq@ti.com> <AE90C24D6B3A694183C094C60CF0A2F6026B744D@saturn3.aculab.com> <529C4726.6080708@ti.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Roger Quadros" <rogerq@ti.com>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
Cc: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <ljkenny.mailinglists@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roger Quadros [mailto:rogerq@ti.com]
> On 11/29/2013 03:17 PM, David Laight wrote:
...
> >> +	timeout = jiffies + msecs_to_jiffies(100);
> >> +	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
> >> +			& OMAP_UHH_SYSSTATUS_RESETDONE)) {
> >> +		cpu_relax();
> 
> You mean use msleep(1) here instead of cpu_relax()?
> Shouldn't be a problem IMO, but can you please tell me why that is better
> as the reset seems to complete usually in the first iteration.

If it doesn't finish in the first iteration you don't want to
spin the cpu for 100ms.

If it hasn't finished in the first millisecond, you probably expect
it to actually time out - so you might as well look (say) every 10ms.

	David



