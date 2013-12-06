Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3LFQ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:29:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14904 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3LFQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:29:29 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-c6-52a1fb625a3c
From: Kamil Debski <k.debski@samsung.com>
To: "'Matt Porter'" <matt.porter@linaro.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-6-git-send-email-k.debski@samsung.com>
 <52A1B0F7.2050501@ti.com> <20131206150101.GA31091@beef>
In-reply-to: <20131206150101.GA31091@beef>
Subject: RE: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver
 with the generic phy framework
Date: Fri, 06 Dec 2013 17:29:21 +0100
Message-id: <00fd01cef2a0$51fc4720$f5f4d560$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7ylAChl3MwBfILQTSjK5POnr48xAADCWnQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xK7pJvxcGGTybq2qxZPcNVov5R86x
	WvS/Wchq0XblILvF5YWXWC0uPO1hszjb9AbI3TWHzWLG+X1MFouWtTJbrD1yl93ibP9tNouJ
	TdPYLc5v6WSyOPymndVi/YzXLBYdZw+yOwh6XO7rZfLYOesuu8eda3vYPPq2rGL0OH5jO5PH
	501yAWxRXDYpqTmZZalF+nYJXBm9C3+yFTzhr3i7eBl7A+MMni5GDg4JAROJ9nUBXYycQKaY
	xIV769m6GLk4hASWMko82H+SFcJpYJK4v+YaC0gDm4CmxKp7HiANIgJhEvs2NTKB1DALHGaW
	6LjznBEkISSwk1Fi3XZ7EJtTQEti+oW/YHFhgTyJ3U82MYHMYRFQldj7oRYkzCvgIHHn1TtW
	CFtQ4sfkeywgNjNQ6/qdx5kgbHmJzWveMkPcrC7x6K8uxAlGEv/mvGeHKBGRuNvwnHUCo9As
	JJNmIZk0C8mkWUhaFjCyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQIicsvOxgXH7M6xCjA
	wajEw5uwZkGQEGtiWXFl7iFGCQ5mJRHeI3cWBgnxpiRWVqUW5ccXleakFh9iZOLglGpgbI4T
	UXr7LP3ulYVxHm6JeRuXOHVypAlKru/pOTpXUtkjuPrOsReVv11yBJ6/DbJdLnjvLO+X+gkP
	/9tszlVwXjmz3Ox33g7FgmAt23Xhvhu3JQsapPXZ/d2t7n5Zpnh2kv7s4uvxRg/Z7D9oJJma
	rNKMunIhTX31obhMBc6bK7eXTl/3fwe7EktxRqKhFnNRcSIAu2cXdKkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Matt Porter [mailto:matt.porter@linaro.org]
> Sent: Friday, December 06, 2013 4:01 PM
> 
> On Fri, Dec 06, 2013 at 04:41:51PM +0530, Kishon Vijay Abraham I wrote:
> > Hi,
> >
> > On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> > > Change the used phy driver to the new Exynos USB phy driver that
> > > uses the generic phy framework.
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
> > >  drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++--
> ---
> > >  2 files changed, 10 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/usb/samsung-
> hsotg.txt
> > > b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > index b83d428..9340d06 100644
> > > --- a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > +++ b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > @@ -24,6 +24,8 @@ Required properties:
> > >      - first entry: must be "otg"
> > >  - vusb_d-supply: phandle to voltage regulator of digital section,
> > >  - vusb_a-supply: phandle to voltage regulator of analog section.
> > > +- phys: from general PHY binding: phandle to the PHY device
> > > +- phy-names: from general PHY binding: should be "usb2-phy"
> >
> > are you sure it's usb2-phy. The example below seems to have a
> different value.
> 
> I requested this be changed to usb2-phy, looks like he just missed the
> update to the example.

This is true. I missed the change in the example part of the file.

> 
> >
> > >
> > >  Example
> > >  -----
> > > @@ -36,5 +38,7 @@ Example
> > >  		clock-names = "otg";
> > >  		vusb_d-supply = <&vusb_reg>;
> > >  		vusb_a-supply = <&vusbdac_reg>;
> > > +		phys = <&usb2phy 0>;
> > > +		phy-names = "device";
> > >  	};

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

