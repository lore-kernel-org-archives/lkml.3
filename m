Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3KMCAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:00:12 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7275 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3KMCAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:00:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Nov 2013 17:54:26 -0800
Message-ID: <5282DD1C.4000307@nvidia.com>
Date: Wed, 13 Nov 2013 10:59:56 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 4/7] ARM: tegra: add support for Trusted Foundations
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com> <1383819106-1400-5-git-send-email-acourbot@nvidia.com> <52828E31.8010408@wwwdotorg.org>
In-Reply-To: <52828E31.8010408@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 05:23 AM, Stephen Warren wrote:
> On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
>> Register the firmware operations for Trusted Foundations if the device
>> tree indicates it is active on the device.
>
>> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
>
>>   void __init tegra_init_early(void)
>>   {
>> +	of_register_trusted_foundations();
>>   	tegra_cpu_reset_handler_init();
>>   	tegra_apb_io_init();
>>   	tegra_init_fuse();
>
> Your other bugfix patch for 3.13 moved tegra_cpu_reset_handler_init().
> Should the call to of_register_trusted_foundations() move with it when
> this is applied, or should it just stay right at the start of
> tegra_init_early()? Either way is fine; just let me know which way to
> fix up the conflict when this gets applied.

I rebased on -next and left it at the start of tegra_init_early(). Even 
though at the moment the only requirement is that the call is made 
before tegra_cpu_reset_handler_init(), it seems to make sense to get rid 
of firmware-related initialization as early as possible.

Btw, this patchset is still based on the 3.12 code, before common.c got 
renamed to tegra.c, so you will have a problem here as well (sorry about 
that). The conflict is easy to resolve, but if you want me to send you a 
properly rebased version, just let me know.

