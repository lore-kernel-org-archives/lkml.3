Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3LMOVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:21:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28117 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3LMOVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:21:03 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-37-52ab17cd98ac
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-2-git-send-email-k.debski@samsung.com>
 <52A16104.3080704@ti.com> <009901cef271$3c40d0b0$b4c27210$%debski@samsung.com>
 <52A56FC0.8020001@ti.com>
In-reply-to: <52A56FC0.8020001@ti.com>
Subject: RE: [PATCH 1/9] phy: core: Change the way of_phy_get is called
Date: Fri, 13 Dec 2013 15:20:59 +0100
Message-id: <008901cef80e$8cac3650$a604a2f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac70r3r6pTqKaNJVQ8O8oal9WN+I7QDXu32Q
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xK7pnxVcHGSy9ImGxZPcNVov5R86x
	WvS/Wchq0XblILvF5YWXWC0uPO1hszjb9AbI3TWHzWLG+X1MFouWtTJbrD1yl93ibP9tNouJ
	TdPYLc5v6WSyOPymndVi/YzXLBYdZw+yOwh6XO7rZfLYOesuu8eda3vYPPq2rGL0OH5jO5PH
	501yAWxRXDYpqTmZZalF+nYJXBmfj9xjL1gmXHH+2yqWBsbZvF2MnBwSAiYSk18vZIawxSQu
	3FvP1sXIxSEksJRRYv2tDiYIp4FJ4vf+J0BVHBxsApoSq+55gDSICOhILDy9HqyZWeAus8SZ
	ZQIQ9W8YJe79PcIEkuAUUJN4s+wkK4gtLOAu0fFnOyOIzSKgKvH+XTMbiM0r4CBxrP8eK4Qt
	KPFj8j0WiKFaEut3HmeCsOUlNq95C3aDhIC6xKO/uhA3GEl0TDkEVSIicbfhOesERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREptfdzAuPWZ1iFGAg1GJ
	h/cm9+ogIdbEsuLK3EOMEhzMSiK8XnxAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxs6smLH8uU
	10WpbJwWGPBL8m3A9DdNj32VG3TTJ02tkU263nb7fKsUo/rFIy0e+SyOtx1TVysJRQWWvP16
	Vdg5q2Zb+99NG5fMfsBW/OakR8DXhULX66VFdu9nEd3wdNXZx4zGvm36+8yDzEKuS66L25oU
	eGeBOLNiGKvtijMTnucwdy/59kWJpTgj0VCLuag4EQCOhlpjqwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Monday, December 09, 2013 8:23 AM
> 
> On Friday 06 December 2013 04:22 PM, Kamil Debski wrote:
> > Hi,
> >
> >> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> >> Sent: Friday, December 06, 2013 6:31 AM
> >>
> >> Hi,
> >>
> >> On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> >>> Previously the of_phy_get function took a struct device * and was
> >>> declared static. It was impossible to call it from another driver
> >>> and thus it was impossible to get phy defined
> >>
> >> It was never intended to be called from other drivers. What's up
> with
> >> the wrapper of of_phy_get, phy_get()/devm_phy_get()? Why isn't that
> >> enough?
> >
> > Implementing support for multiple phys in the ehci driver is a bit
> tricky.
> > Especially when we want to do it right. Please have a look at this
> > part of the dts file:
> >
> > +    ehci@12580000 {
> > +        compatible = "samsung,exynos4210-ehci";
> > +        reg = <0x12580000 0x20000>;
> > +        interrupts = <0 70 0>;
> > +        clocks = <&clock 304>, <&clock 305>;
> > +        clock-names = "usbhost", "otg";
> > +        status = "disabled";
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +        port@0 {
> > +            reg = <0>;
> > +            phys = <&usb2phy 1>;
> > +            phy-names = "host";
> > +            status = "disabled";
> > +        };
> > +        port@1 {
> > +            reg = <1>;
> > +            phys = <&usb2phy 2>;
> > +            phy-names = "hsic0";
> > +            status = "disabled";
> > +        };
> > +        port@2 {
> > +            reg = <2>;
> > +            phys = <&usb2phy 3>;
> > +            phy-names = "hsic1";
> > +            status = "disabled";
> > +        };
> > +    };
> >
> > With the above we have a clear specification of ports and their
> > respective phys. But to do this properly the ehci driver has to
> > iterate over port nodes. It is much easier to use devm_of_phy_get by
> > giving the node as its argument.
> 
> I see. There are a couple of more things we do in the wrapper that gets
> missed while exporting of_phy_get (get_device and try_module_get). You
> might want to re-work that one.

Thank you for the review. I have just sent an updated version of the core
patches.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland



