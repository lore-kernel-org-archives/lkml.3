Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3LFKwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:52:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57763 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3LFKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:52:21 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-96-52a1ac63fa2f
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-2-git-send-email-k.debski@samsung.com>
 <52A16104.3080704@ti.com>
In-reply-to: <52A16104.3080704@ti.com>
Subject: RE: [PATCH 1/9] phy: core: Change the way of_phy_get is called
Date: Fri, 06 Dec 2013 11:52:18 +0100
Message-id: <009901cef271$3c40d0b0$b4c27210$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yRFgY0CO1onqnSuOtVYXVIbU/CAAKzmww
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xy7rJaxYGGcy7pG6xZPcNVov5R86x
	WvS/Wchq0XblILvF5YWXWC0uPO1hszjb9AbI3TWHzWLG+X1MFouWtTJbrD1yl93ibP9tNouJ
	TdPYLc5v6WSyOPymndVi/YzXLBYdZw+yOwh6XO7rZfLYOesuu8eda3vYPPq2rGL0OH5jO5PH
	501yAWxRXDYpqTmZZalF+nYJXBk9h0+xFqzjq7j/bhl7A+MNzi5GTg4JAROJrY/vMkHYYhIX
	7q1n62Lk4hASWMooseD9fVYIp4FJ4vzvr4xdjBwcbAKaEqvueYDERQRWMEoceHCcGcRhFnjI
	JLHz8Qqo9tmMEpvXX2EDmcspoCaxdfJvFhBbWMBdouPPdkYQm0VAVeLjj/lgNbwCDhKdS1ez
	QtiCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aQKyQE1CUe/dUFCYsIGEn0zl7ADFEiInG34Tnr
	BEahWUgmzUIyaRaSSbOQtCxgZFnFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERKfX3YwLj5m
	dYhRgINRiYc3Yc2CICHWxLLiytxDjBIczEoivDbLFwYJ8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YGT4Pql6w/ZjOfaHhXYmXbsbWSAYHuhvYuv8J4XrvUtRsnWGgrFK79Iu16snn+VnFpjfVN24
	ez9jknecc27Z/Sl2mxmXGYe+X5NxlcUz92P3w6LFcnavZLLstu7zjp99rNJz+XVB2zkLFmVO
	5OFeFLs/4mzp9xM+Z7Pvrzv7b4XFrV1dCUu1NimxFGckGmoxFxUnAgCkUXzFrQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Friday, December 06, 2013 6:31 AM
> 
> Hi,
> 
> On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> > Previously the of_phy_get function took a struct device * and was
> > declared static. It was impossible to call it from another driver and
> > thus it was impossible to get phy defined
> 
> It was never intended to be called from other drivers. What's up with
> the wrapper of of_phy_get, phy_get()/devm_phy_get()? Why isn't that
> enough?

Implementing support for multiple phys in the ehci driver is a bit tricky.
Especially when we want to do it right. Please have a look at this part of
the dts file:

+    ehci@12580000 {
+        compatible = "samsung,exynos4210-ehci";
+        reg = <0x12580000 0x20000>;
+        interrupts = <0 70 0>;
+        clocks = <&clock 304>, <&clock 305>;
+        clock-names = "usbhost", "otg";
+        status = "disabled";
+        #address-cells = <1>;
+        #size-cells = <0>;
+        port@0 {
+            reg = <0>;
+            phys = <&usb2phy 1>;
+            phy-names = "host";
+            status = "disabled";
+        };
+        port@1 {
+            reg = <1>;
+            phys = <&usb2phy 2>;
+            phy-names = "hsic0";
+            status = "disabled";
+        };
+        port@2 {
+            reg = <2>;
+            phys = <&usb2phy 3>;
+            phy-names = "hsic1";
+            status = "disabled";
+        };
+    };

With the above we have a clear specification of ports and their respective
phys. But to do this properly the ehci driver has to iterate over port
nodes. It is much easier to use devm_of_phy_get by giving the node as its
argument.

[snip]

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


