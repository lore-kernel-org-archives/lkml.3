Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3FNPZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:25:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51420 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3FNPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:25:21 -0400
Message-ID: <51BB35DD.4030004@wwwdotorg.org>
Date: Fri, 14 Jun 2013 09:25:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: tegra: basic support for Trusted Foundations
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com> <1371114745-24710-2-git-send-email-acourbot@nvidia.com> <51BA1B41.6030002@wwwdotorg.org> <CAAVeFuLc57pV=To5yaE5x9mrVy1yknH2e90QockCiNbEXRm0WQ@mail.gmail.com>
In-Reply-To: <CAAVeFuLc57pV=To5yaE5x9mrVy1yknH2e90QockCiNbEXRm0WQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 02:27 AM, Alexandre Courbot wrote:
> On Fri, Jun 14, 2013 at 4:19 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
>>> Add basic support for booting secondary processors on Tegra devices
>>> using the Trusted Foundations secure monitor.

>>> diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c
>>
>>> +void __init tegra_init_firmware(void)
...
>>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
>>> +     if (node && !IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))
>>> +             pr_warn("Trusted Foundations detected but support missing!\n");
>>> +#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
>>> +     else if (node)
>>> +             register_firmware_ops(&tegra_trusted_foundations_ops);
>>> +#endif
>>> +}
>>
>> Is it worth continuing on in the node && !IS_ENABLED case here? After
>> all, we can be pretty certain that the write to the CPU reset vector is
>> immediately going to trap...
> 
> That's what was happening until 3.9, but from 3.10 on the trap is
> apparently handled and the boot completes (although with only one
> processor).

Why does that happen; surely the kernel shouldn't be ignoring failures?
How does it recover?
