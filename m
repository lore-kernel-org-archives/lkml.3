Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3KRRws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:52:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50521 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3KRRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:52:39 -0500
Message-ID: <528A53E4.90401@wwwdotorg.org>
Date: Mon, 18 Nov 2013 10:52:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Alex Courbot <acourbot@nvidia.com>, Alexandre Courbot <gnurou@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com> <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com> <52898417.80601@nvidia.com> <20131118115842.GE4050@arm.com> <528A4869.2020701@wwwdotorg.org> <20131118173047.GF9838@arm.com>
In-Reply-To: <20131118173047.GF9838@arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 10:30 AM, Catalin Marinas wrote:
> On Mon, Nov 18, 2013 at 05:03:37PM +0000, Stephen Warren wrote:
>> On 11/18/2013 04:58 AM, Catalin Marinas wrote:
>> ...
>>> Of course, trusted foundations interface could be plugged into cpu_ops
>>> on arm64 but I will NAK it on the grounds of not using the PSCI API, nor
>>> the SMC calling convention (and it's easy to fix when porting to ARMv8).
>>> If a supported standard API is used, then there is no need for
>>> additional code in the kernel.
>>
>> What happens when someone takes an existing working secure-mode SW stack
>> and simply re-uses it on some new ARMv8 SoC. Are you going to force
>> people working on upstream to re-write the secure mode firmware in
>> shipped hardware before allowing upstream kernel support?
> 
> Don't confuse the secure stack with the secure monitor running at EL3.
> If you want AArch64 support for lower levels (EL2, EL1, EL0), your
> monitor _must_ be AArch64. You can't run legacy AArch32 code at EL3 and
> have lower levels in AArch64 mode (architectural constraint).

I was assuming that vendors would take the existing source code and
simply rebuild it to create the AArch64 secure world. As such, the same
SMC IDs, same structures, etc. would be used. The only source difference
would be to perhaps change some 32-bit registers/struct-fields up to
64-bit. Naively that sounds like the lowest-effort way to get an AArch64
secure world, so I'm purely guessing that that's what vendors will do.

> You can
> still keep the secure services at S-EL1 in AArch32, only that the SMCs
> are handled by EL3 (and that's another aspect the SMC calling convention
> spec is trying to address, mixed register-width secure/non-secure OSes).

I'm not sure of the implications of that statement. Since you mention
SMCs being handled by EL3, I think the quick-and-dirty conversion I
mention above is still likely to be used.
