Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaBYM1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:27:42 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37757 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBYM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:27:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140221162824.GA4706@obsidianresearch.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
	<CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
	<20140219003523.GJ29304@obsidianresearch.com>
	<CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
	<20140220174503.GB19893@obsidianresearch.com>
	<CA+mB=1L+QM2cKq==mwYesp=E7S2N-xTiN7AoBvbzAO2UMn0qVQ@mail.gmail.com>
	<20140221162824.GA4706@obsidianresearch.com>
Date: Tue, 25 Feb 2014 17:57:37 +0530
X-Google-Sender-Auth: YZMg5oNVgSqnBfSH7CxP9phAtMk
Message-ID: <CA+mB=1Jner0G2cyKrGom8-mKrRpvwO6bj2Xob5BbtJMKbMLkuQ@mail.gmail.com>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Fri, Feb 21, 2014 at 9:58 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Feb 21, 2014 at 08:18:00PM +0530, Srikanth Thokala wrote:
>
>> 00:00.0 Class 0604: Device 10ee:7081
>
> So this is great, a root port bridge is exactly correct - I would
> recommend using device 1 for this (device 0 is the host bridge in most
> cases), but I don't think that has any functional impact.
>
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>         I/O behind bridge: 00000000-00000fff
>>         Memory behind bridge: 00000000-000fffff
>>         Prefetchable memory behind bridge: 00000000-000fffff
>
> What is going on here?  These ranges should match the MMIO aperture and
> critically must enclose the downstream bars:
>
>> 01:00.0 Class 0200: Device 14e4:1677 (rev 11)
>>         Region 0: Memory at 60000000 (64-bit, non-prefetchable) [size=64K]
>>         Expansion ROM at 60010000 [disabled] [size=64K]
>
> So one of those two is not right..

Sorry for the delay in response.  Thanks for pointing this.
I have series of conversations with my IP team and it is giving back
zero's when Type1 Header
Memory Base offset is read even the pcie stack writes the valid
addresses.  HW team is working on
this and they will take their own time to give a fix.  As there is no
functional impact, I believe there
is no issue with driver and should work on mainlining the driver.
Please suggest me on how to
proceed and accordingly I will send a v2 patch fixing the DT comments
pointed by you and Bjorn.

Thanks
Srikanth

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
