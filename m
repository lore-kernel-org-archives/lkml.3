Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3FFKh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:37:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9801 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3FFKh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:37:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 03:37:54 -0700
Message-ID: <51B0667D.30801@nvidia.com>
Date: Thu, 6 Jun 2013 19:37:49 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <1740292.8Sz57ytBcM@flatron>
In-Reply-To: <1740292.8Sz57ytBcM@flatron>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/06/2013 07:17 PM, Tomasz Figa wrote:
>> +Global properties
>> +-------------------------------------------
>> +
>> +The following properties can be specified into the "chosen" root
>> +node:
>> +
>> +  nvidia,secure-os: enable SecureOS.
>
> Hmm, on Exynos we had something like
>
>          firmware@0203F000 {
>                  compatible = "samsung,secure-firmware";
>                  reg = <0x0203F000 0x1000>;
>          };
>
> but your solution might be actually the proper one, since firmware is not
> a hardware block. (The address in reg property is pointing to SYSRAM
> memory, which is an additional communication channel with the firmware.)

Yes, I saw your implementation but decided to do it through the chosen 
node anyway, since that's what it seems to be designed and we don't need 
any reg parameter.

> I think this patch could be split into several patches:
>   - add support for firmware
>   - split reset function
>   - add reset support using firmware.

Mmm possibly yes, but I wonder if that would not be too much splitting. 
Stephen?

> Hmm, I wonder if you need all this complexity here. Have a look at our
> exynos_smc function
>
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/mach-exynos/exynos-smc.S?id=refs/tags/next-20130606

Yes, I just embarrassed myself showing my ignorance of ARM assembler. ;) 
The fix Russel proposed is pretty close to your version.

>> +static const struct firmware_ops tegra_firmware_ops = {
>> +     .set_cpu_boot_addr = tegra_set_cpu_boot_addr,
>> +};
>
> It's good that this interface is finally getting some user besides Exynos.

I didn't know about it first but Joseph kindly pointed it out to me and 
it indeed makes it easier to implement this.

Thanks,
Alex.


