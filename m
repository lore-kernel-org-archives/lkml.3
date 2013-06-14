Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FNIzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:55:23 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58739 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3FNIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <51BA1C3D.1010608@wwwdotorg.org>
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
 <1371114745-24710-4-git-send-email-acourbot@nvidia.com> <51BA1C3D.1010608@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 14 Jun 2013 17:54:59 +0900
Message-ID: <CAAVeFuLi6-WnFP9LvEdqfj2cuK7pgW0_pg33i-Ucoobcxb8RSQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: tegra: set CPU reset handler with firmware op
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 4:23 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
>> Use a firmware operation to set the CPU reset handler and only resort to
>> doing it ourselves if there is none defined.
>>
>> This supports the booting of secondary CPUs on devices using a TrustZone
>> secure monitor.
>
>> diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
>
>> +     err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
>> +     switch (err) {
>> +     case -ENOSYS:
>> +             tegra_cpu_reset_handler_set(reset_address);
>> +             /* pass-through */
>
> Rather than detecting -ENOSYS and falling back to the custom
> tegra_cpu_reset_handler_set(), does it make sense to plug in
> tegra_cpu_reset_handler_set as the firmware op when there is no secure
> firmware detected? That way, this code wouldn't need the special case;
> that would be isolated to firmware.c.

Mmmm I admit I just followed what Exynos did without thinking much
about it. I don't see any reason why your suggestion wouldn't work,
but on second thought tegra_cpu_reset_handler_set() is not a firmware
operation - wouldn't it be unexpected (and maybe confusing) to have it
called through call_firmware_op()?

Alex.
