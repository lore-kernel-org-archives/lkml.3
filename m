Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3ASOsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 09:48:33 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:45178 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3ASOsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 09:48:32 -0500
Message-ID: <50FAB219.5020108@free.fr>
Date: Sat, 19 Jan 2013 15:47:53 +0100
From: dAgeCKo <dagecko@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, Shane Huang <Shane.Huang@amd.com>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: Fwd: Linux - AMD SB950 USB Regression
References: <50C9FCD6.6050809@free.fr> <50E6AD77.1000707@free.fr> <50F036CF.7010109@free.fr> <20130117213602.GA5998@pd.tnic>
In-Reply-To: <20130117213602.GA5998@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/01/2013 22:36, Borislav Petkov a écrit :

>
> So, there seems to be some serious breakage with GART on SB9xx. I don't
> know whether this is the platform BIOS or the vendor BIOS causing it
> because the original bug reporter says he observes the issue on an MSI
> board and I'm experiencing this on my favourite bunch ASUS.
>
> So, if you use the GART as an IOMMU, i.e.:
>
> Jan 17 22:08:15 pd kernel: [    0.924063] PCI-DMA: using GART IOMMU.
> Jan 17 22:08:15 pd kernel: [    0.924120] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
>
> USB ports start choking like this:
>
> Jan 17 22:08:15 pd kernel: [    3.229909] usb 4-1: device descriptor read/64, error -32
> Jan 17 22:08:15 pd kernel: [    3.432786] usb 4-1: new high-speed USB device number 3 using ehci-pci
> Jan 17 22:08:15 pd kernel: [    3.534684] usb 4-1: device descriptor read/64, error -32
> Jan 17 22:08:15 pd kernel: [    3.737642] usb 4-1: device descriptor read/64, error -32

Yes, this is exactly what I faced.

>
> I'd go and venture a guess here since I don't have an idea that DMA
> somehow gets busted with the GART and thus the errors.
>
> Now, those boards normally have an IOMMU too so if you go and enable
>
> CONFIG_AMD_IOMMU=y
>
> the problem is gone (we're using the real IOMMU for DMA mapping, etc,
> etc). So dAgeCKo, that would be another thing you could do: try enabling
> the IOMMU in the BIOS and the above CONFIG option and the issue would be
> fixed too.

Here is below, exactly what the guy from MSI said me after I said him a 
BIOS upgrade did resolve my bug:

"The  reacts differently to Win/Linux, but it relies on updates by AMD. 
The new AGESA in the BIOS might had fixes for Linux."

After few researches, it seems that this "BIOS-level" software has 
effectively a special implementation wrapper for Linux (something I 
can't understand why actually). For more reference you can find little 
information here 
(http://www.coreboot.org/data/LinuxBIOS%20AMD%202006%20Final_10-02-2006.pdf).

I can't try the solution you are giving since I can't (and don't want to 
try to) downgrade my BIOS.

Another important thing you might be interested in is that not only my 
USB 2 weren't working. My mainboard ethernet wasn't working to (and was 
resolved with the BIOS upgrade too). The ethernet chip is:

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)

I don't know if that can be related to what you are saying.

>
> At least this fixes it on my box.
>
> To the question "how do we fix the GART issue?" I have no answer and
> would expect more informed opinions from someone else.

Actually I can't tell if I have any GART issues. The only thing I can 
say is that 3D looks to work nicely. However I think I never consumed 
more memory than my graphic card has.

>
> Thanks and HTH.
>

Thanks you too.
