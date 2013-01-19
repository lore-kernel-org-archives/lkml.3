Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3ASQf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:35:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40373 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab3ASQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:35:54 -0500
Date: Sat, 19 Jan 2013 17:35:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: dAgeCKo <dagecko@free.fr>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Shane Huang <Shane.Huang@amd.com>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: Fwd: Linux - AMD SB950 USB Regression
Message-ID: <20130119163546.GB4026@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, dAgeCKo <dagecko@free.fr>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	Shane Huang <Shane.Huang@amd.com>,
	=?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
References: <50C9FCD6.6050809@free.fr>
 <50E6AD77.1000707@free.fr>
 <50F036CF.7010109@free.fr>
 <20130117213602.GA5998@pd.tnic>
 <50FAB219.5020108@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50FAB219.5020108@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 03:47:53PM +0100, dAgeCKo wrote:
> I can't try the solution you are giving since I can't (and don't want
> to try to) downgrade my BIOS.

I don't think I said that. Here's what I actually said:

>> So dAgeCKo, that would be another thing you could do: try enabling
>> the IOMMU in the BIOS and the above CONFIG option and the issue would
>> be fixed too.

IOW, you enter the BIOS, go to "NB settings" or similar and set IOMMU
to Auto/Enabled. Provided you have an IOMMU but you should have that on
this chipset.

Then, you enable CONFIG_AMD_IOMMU in your kernel and done: the kernel
uses the IOMMU hardware instead of the GART.

That's it, no need for any BIOS up-/downgrading.

> Another important thing you might be interested in is that not only
> my USB 2 weren't working. My mainboard ethernet wasn't working to
> (and was resolved with the BIOS upgrade too). The ethernet chip is:
> 
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
> 
> I don't know if that can be related to what you are saying.

It could be, my nic kept resetting and once got an xmit queue timeout so
it could very well be related.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
