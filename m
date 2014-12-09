Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaLILHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:07:33 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7282 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbaLILHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:07:31 -0500
X-IronPort-AV: E=Sophos;i="5.07,544,1413270000"; 
   d="scan'208";a="52761815"
Message-ID: <5486D7EF.6010902@broadcom.com>
Date: Tue, 9 Dec 2014 12:07:27 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
References: <5481794E.4050406@broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com> <2863746.4sUSEYqahB@wuerfel> <20141208160316.GM16185@e104818-lin.cambridge.arm.com> <5485D97D.1040404@broadcom.com> <5486CCBC.3@broadcom.com> <20141209102904.GJ11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141209102904.GJ11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 11:29, Russell King - ARM Linux wrote:
> On Tue, Dec 09, 2014 at 11:19:40AM +0100, Arend van Spriel wrote:
>> The issue did not trigger overnight so it seems setting bit 22<Shared
>> Attribute _Override_ Enable>  solves the issue over here. Now the question is
>> how to move forward with this. As I understood from Catalin this patch was
>> not included as it was not considered responsibility of the linux kernel.
>
> It is preferable for firmware to configure the L2 cache appropriately,
> which includes things like the prefetch offsets as well as feature bits
> like bit 22.
>
> I think what I'll do is queue up a patch which adds a warning if bit 22
> is not set, suggesting that firmware is updated to set this bit.

I was thinking in the same direction. Thanks to you all for looking into 
this. It did not feel right to use the dma_sync_single_for_cpu() for 
memory allocated with dma_alloc_coherent() and I am glad this got 
cleared up.

Regards,
Arend

