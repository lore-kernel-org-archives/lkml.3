Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3JNSRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:17:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52662 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3JNSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <52591F7A.1020400@ti.com>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
	<52579592.1020209@ti.com>
	<CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
	<52591F7A.1020400@ti.com>
Date: Mon, 14 Oct 2013 20:17:38 +0200
Message-ID: <CAPNxggbJkXK_RhaWSfXZKFc=iy-2UmkEukCsbOUzYSmbcqmoKw@mail.gmail.com>
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

On Sat, Oct 12, 2013 at 12:07 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Friday 11 October 2013 10:52 PM, Arokux X wrote:
>>> I think you should have a wrapper driver to EHCI/OHCI to handle this reset.
>>
>> Thank you Kishon and Peter for the quick replies. Is there any good
>> example of such a wrapper driver in the kernel already?
>
> can you explain how your IP actually looks like? Do you have separate address
> space for EHCI and OHCI? Do you have any common address space for doing some
> configuration (USB host in OMAP used to have it)? Where does PHY registers
> reside exactly?

The knowledge I have about the IP is derived from the source code of
the different kernel trees some of which were leaked and the others
released by Allwinner. I cannot really see similarities to the other
USB IPs supported by the mainline kernel since I have zero experience
with kernel development and this simple bus glue driver is going to be
my first contribution.

USB Host Controller as available in Allwinner SoCs supports EHCI and
OHCI. The address spaces of EHCI and OHCI are separate. Let the
address of the host controller be X, then EHCI is at X and OHCI is at
X+OHCI_OFFSET, where OHCI_OFFSET = 0x100.

The driver in the vendor's tree also touches the address X + 0x800 and
enables DMA burst, similar to the SAMSUNG S5P USB HOST EHCI Controller
[1].

In addition another memory location is touched to configure the PHY.
At that place two things occur [2]: "adjust PHY's magnitude and rate"
and adjusting the threshold of the disconnect. (Both are translated
from Chinese and I'm not sure whether the former is correct).

There are either two or one USB Host Controllers in a SoC. For each
controller there are EHCI and OHCI gatable clocks, one common clock
for all the PHYs and one reset bit for each PHY.

I think this is pretty much it. As you see the EHCI and OHCI parts are
almost independent from each other. The only problem is the common
reset bit which I do not know how to manage. Any help is highly
appreciated.

Best regards,
Arokux

[1] http://lxr.free-electrons.com/source/drivers/usb/host/ehci-s5p.c#L34
[2] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be#diff-2fdea331a4331eca7c86f18cd2d87e72R89
