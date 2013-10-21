Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3JUJDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:03:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46011 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab3JUJC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:02:58 -0400
Message-ID: <5264EDB7.6030104@ti.com>
Date: Mon, 21 Oct 2013 14:32:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arokux X <arokux@gmail.com>
CC: <peter.chen@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, <rbyshko@gmail.com>
Subject: Re: When USB PHY framework should be used?
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com> <52579592.1020209@ti.com> <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com> <52591F7A.1020400@ti.com> <CAPNxggbJkXK_RhaWSfXZKFc=iy-2UmkEukCsbOUzYSmbcqmoKw@mail.gmail.com>
In-Reply-To: <CAPNxggbJkXK_RhaWSfXZKFc=iy-2UmkEukCsbOUzYSmbcqmoKw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Roman

Hi,

Sorry for the late reply..

On Monday 14 October 2013 11:47 PM, Arokux X wrote:
> Dear Kishon,
> 
> On Sat, Oct 12, 2013 at 12:07 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi,
>>
>> On Friday 11 October 2013 10:52 PM, Arokux X wrote:
>>>> I think you should have a wrapper driver to EHCI/OHCI to handle this reset.
>>>
>>> Thank you Kishon and Peter for the quick replies. Is there any good
>>> example of such a wrapper driver in the kernel already?
>>
>> can you explain how your IP actually looks like? Do you have separate address
>> space for EHCI and OHCI? Do you have any common address space for doing some
>> configuration (USB host in OMAP used to have it)? Where does PHY registers
>> reside exactly?
> 
> The knowledge I have about the IP is derived from the source code of
> the different kernel trees some of which were leaked and the others
> released by Allwinner. I cannot really see similarities to the other
> USB IPs supported by the mainline kernel since I have zero experience
> with kernel development and this simple bus glue driver is going to be
> my first contribution.
> 
> USB Host Controller as available in Allwinner SoCs supports EHCI and
> OHCI. The address spaces of EHCI and OHCI are separate. Let the
> address of the host controller be X, then EHCI is at X and OHCI is at
> X+OHCI_OFFSET, where OHCI_OFFSET = 0x100.
> 
> The driver in the vendor's tree also touches the address X + 0x800 and
> enables DMA burst, similar to the SAMSUNG S5P USB HOST EHCI Controller
> [1].
> 
> In addition another memory location is touched to configure the PHY.
> At that place two things occur [2]: "adjust PHY's magnitude and rate"
> and adjusting the threshold of the disconnect. (Both are translated
> from Chinese and I'm not sure whether the former is correct).
> 
> There are either two or one USB Host Controllers in a SoC. For each
> controller there are EHCI and OHCI gatable clocks, one common clock
> for all the PHYs and one reset bit for each PHY.

>From whatever I could understand, you have a USB HOST controller (each HOST
controller has an EHCI controller and a companion OHCI controller?). There are
separate clocks for each of EHCI and OHCI controller. EHCI and OHCI has
separate PHYs. Both these PHYs are fed by the same common clock. And you have a
separate reset bits for each of the PHYs.
And when you have a second USB HOST controller, you have a new instance of the
same thing as before?

Thanks
Kishon
