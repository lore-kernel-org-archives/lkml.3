Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3JULTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:19:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34024 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3JULTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <5264EDB7.6030104@ti.com>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
	<52579592.1020209@ti.com>
	<CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
	<52591F7A.1020400@ti.com>
	<CAPNxggbJkXK_RhaWSfXZKFc=iy-2UmkEukCsbOUzYSmbcqmoKw@mail.gmail.com>
	<5264EDB7.6030104@ti.com>
Date: Mon, 21 Oct 2013 13:19:46 +0200
Message-ID: <CAPNxggbs6hJtPA+2kqg34D8kV73BdNft2kZdMhUKtsAD=SsCnA@mail.gmail.com>
Subject: Re: When USB PHY framework should be used?
From: Arokux X <arokux@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: peter.chen@freescale.com, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kishon,

thank you for the answer, no problem it was late! Your understanding
is almost correct.

> From whatever I could understand, you have a USB HOST controller (each HOST
> controller has an EHCI controller and a companion OHCI controller?). There are
> separate clocks for each of EHCI and OHCI controller. EHCI and OHCI has
> separate PHYs. Both these PHYs are fed by the same common clock. And you have a
> separate reset bits for each of the PHYs.

EHCI and OHCI have the same PHY. And this PHY has a reset bit. This is
exactly what bothers me. Because there should be something central to
both EHCI and OHCI which manages this reset bit, i.e. the bit should
be cleared if and only if both EHCI and OHCI controllers are unloaded
(as modules). I have done a nice picture of the hardware here, please
take a look at it:

http://linux-sunxi.org/User:Arokux#USB_Host_Hardware

I've just realized that there is another commo thing for EHCI and OHCI
- a GPIO which turns on the power to the USB_VBUS. The power should be
supplied if at least one of the EHCI or OHCI is loaded. This again
needs some central management.

So to summarize, I have two things (reset bit and GPIO for the
USB_VBUS) which are common to EHCI and OHCI and need to be managed
outside of the EHCI/OHCI bus glue drivers. My exact question is: where
this management should be done? Are there good examples in the kernel
already?

Thank you in advance for the answer!

Best regards,
Arokux
