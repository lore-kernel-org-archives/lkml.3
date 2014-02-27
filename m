Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaB0KKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:10:53 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21510 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaB0KKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:10:49 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-d8-530f0f26f492
Message-id: <530F0F24.2080903@samsung.com>
Date: Thu, 27 Feb 2014 11:10:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v5 06/11] drivers: of: initialize and assign reserved
 memory to newly created devices
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
 <1392985527-6260-7-git-send-email-m.szyprowski@samsung.com>
 <20140226121445.54D2DC40A89@trevor.secretlab.ca>
In-reply-to: <20140226121445.54D2DC40A89@trevor.secretlab.ca>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWyxbcRzH8+85PedodI4q+8+DbZXdZDPG+Gcz7GkniywW2fWFoqFZW9aO
	jWSbCQ0NdVvCGkzjspGu3crQGplqykjMpeHBZTEicd2GiFjJVn3x9vkmn+/v+/KjMN4Y7kuJ
	ZU9EcplQIiA4+NB+v/3CaQ+PuKDVoXNor9xGot+5+Rj61VQE0FvrMBuVrGrZ6KujE6DV4gIc
	mfTrAHUUVpFoyz7HQsb5CTbSKhtwNG6uJtDHpV4WapwcZaG6/jw2clT6ocHJTQLprPUkKq38
	gKP8biuJ9jqMOFruVeLIULWCoxazA6ClPwN4tC+jq9UB5u9uOWBWKkoBM64uZjEmzQzJFK3m
	sRljSyHBTE98IZjWhpfM1P48xtgHctmM3rHMYkr2gpgasxow6rYWwGwa/WI9H3IikkUScaZI
	fjEygZOqnWom01X8Z80ji3gOqKdVwI2CdCjsmTGwXOwDR2YNhApwKB7dCGDfq122K2wAaFp4
	f2Bx6QA4t/IGdzJOn4LvzK+Bkwk6GKrWVP/bFOVN34G1NYEu3RPuVMzizjt8+huA+91q0hkw
	WknAnFI94bS86Eew7XMV5mQe3QlgqzXByW70Ndg+33cwjNFh8GeeHnPxcdiqW8NKAa05NKI5
	pGkOaXUAawHeooykdEViijQ4UCGUKjJkKYFJaVIjcP3BVieot12xAJoCAnfuSeJIHI8tzFRk
	SS0AUpiAzzWwPOJ43GRhVrZInhYvz5CIFBbAotx8c4DaftZyu7ldElJmimkS353e6LyUzjvj
	ldife8N9w2cde9q17VgIX4/h5A/dvBUVEl+22BTNCbXpc3r4UCb/1BjZOCq+H7H442hvx7Hy
	qzD2+XbIzoi/tvp8rHiQJPlZ96T88OnprsfdxOWCE2EJxMD3ses2/6jhB9lR+hdVyh4BrkgV
	BgdgcoXwH1Q3g5DlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-26 13:14, Grant Likely wrote:
> On Fri, 21 Feb 2014 13:25:22 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > Use recently introduced of_reserved_mem_device_init() function to
> > automatically assign respective reserved memory region to the newly created
> > platform and amba device.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> I'm wary on this patch. It hides the assignment of regions into the core
> code and I worry that it is the wrong level of abstraction. I would
> think that drivers should know that they need a reserved memory region
> and should be calling the API to obtain the region directly rather than
> doing it for them. The reason being is that there may be some situations
> where the common code isn't quite right and the driver needs to override
> the behaviour. If it is called automatically then the driver cannot do
> that.
>
> Is it really a big burden to have the driver call the reserved memory
> init function?

If a device requires very special handling of the reserved memory region,
it may simply provide its own reserved memory region driver which will do
the required early initialization.

If we assume that driver needs to initialize reserved region manually, then
why do we ever bother with adding support for custom reserved memory drivers
and assigning regions to a device node? We can simply stick with just a set
of reserved regions and tell drivers to use them.

In my opinion for most typical use cases a board designer will assign
'dma-shared-pool' driver to the given set of devices, which in turn ensures
that all memory allocations for dma purposes for those device will be
served from that region. It is really not a driver role to initialize it
in such case. Driver should focus on controlling hw operations, regardless
the way the hardware module has been integrated to the system.

I can perfectly imagine a generic driver which operates the same way in any
of the following cases (depends mainly on the hw version): 1) restricted
dma window, 2) iommu for all dma for the given device, 3) fully featured
memory master for dma for the given device (no restrictions), if the
respective kernel subsystems did the correct initialization and provide
their own methods for managing DMA operation. I already have a working
platform glue code for the above cases tested with Samsung multimedia
drivers. No changes to the drivers were required.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

