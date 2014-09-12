Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaILQI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:08:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60225 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaILQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:08:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-94-54131a76e657
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 03/12] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
Date: Fri, 12 Sep 2014 18:08:19 +0200
Message-id: <2456137.rW431zonMs@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-4-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-4-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd0yKeEQg4OrdCwO3q+3mLTuAJPF
	2WUH2SxWfVrDbLHypLZF8+L1bBaXF15itdg2/SeQtWsOm8WiZa3MFgtfX2Ox2D5lOpPFg8M7
	2S1O/ulltHh1sI3Fgd9jdsNFFo+/q14we+ycdZfd4861PWwe++euYffovzaJ3ePvrP0sHn1b
	VjF6fPnxj8Vjy/7PjB7Hb2xn8vi8Sc5j49zQAN4oLpuU1JzMstQifbsEroz1rx4xFUzjq7je
	Fd3AeIa7i5GTQ0LARGLdpI/MELaYxIV769m6GLk4hASmM0osv9IL5bQwSUy+P5cVpIpNwEpi
	YvsqRhBbREBJonfVSxaQImaBs0wSK3atBRslLJAqcXjVMXYQm0VAVWLBundgcV4BTYlTF5ax
	gdiiAp4SO7avBLM5BfwlVqy5wQixbTKjxMXN1xkhGgQlfky+xwJiMwvIS+zbP5UVwtaR2N86
	jW0Co8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwDD6T3sG4qsHi
	EKMAB6MSD28li2CIEGtiWXFl7iFGCQ5mJRFeRVHhECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MDMs+v+fO3il9kjVbyOz52RVh63nN+yu8FJpUZq9+
	ncr1/MukMKWpL5J+3OTQLGo+0J7TZc2XxnBqdnj8Sa5yh9lWNQER6zsl7u7IerK7qPGcX9Xt
	9pq3Lnqu07SOv75hmDNNbYGVgrL0wiROhnvHVpal+O/+8GXJBJWFpz5a8/07oJM+dV6SEktx
	RqKhFnNRcSIA6QWogb0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:54 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Adds the gadget data structure and appropriate data structure pointers
> to the common dwc2_hsotg data structure. To keep the driver data
> dereference code looking clean, the gadget variable declares are only available
> for peripheral and dual-role mode. This is needed so that the dwc2_hsotg data
> structure can be used by the hcd and gadget drivers.
> 
> Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
> that have been moved into the common dwc2_hsotg structure. Along
> with the updating the gadget driver to use the common dwc2_hsotg structure,
> a few other things are required in order for this patch to build properly.
> Those are:
> 
> - Remove gadget module defines. Since the driver probing will be handled
>   by either the platform or pci code.

Removal of gadget module defines should be done in the same patch that
adds gadget functionality probing to platform/PCI new common code.

> - Change the gadget probe function into gadget_init.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v3: Updated with paulz's suggestion to avoid double pointers.
> v2: Left the function parameter name as 'hsotg' and just changed its type.
> ---
>  drivers/usb/dwc2/core.h   | 176 +++++++++++++++++++++---------------
>  drivers/usb/dwc2/gadget.c | 226 +++++++++++++++++-----------------------------
>  drivers/usb/dwc2/hcd.h    |  10 --
>  3 files changed, 184 insertions(+), 228 deletions(-)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

