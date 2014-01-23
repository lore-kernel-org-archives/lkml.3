Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaAWHkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:40:09 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41698 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaAWHjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <52E02DCC.1000404@wwwdotorg.org>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
 <1390299016-14105-6-git-send-email-acourbot@nvidia.com> <52E02DCC.1000404@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 23 Jan 2014 16:39:32 +0900
Message-ID: <CAAVeFuKLtC62+bujY4724hMV_6M8Ow0s=6zRn_M87VX4PHQgxA@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: tegra: cpuidle: use firmware call for power down
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
>> Invoke the do_idle() firmware call before suspending a CPU so that the
>> underlying firmware (if any) can take necessary action.
>
>> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
>
>> @@ -45,6 +46,8 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>>
>>       clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>>
>> +     call_firmware_op(do_idle);
>> +
>>       cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>>
>>       clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>
> Don't you need to have the kernel also *not* do something when entering
> idle; doesn't the FW op replace some of the register writes that the
> kernel would otherwise be doing?

It seems like the operation is actually to inform the firmware that we
are going to suspend the CPU. Downstream kernel also uses it that way.
But you are right in that we should expect do_idle() to actually
perform the suspend operation. Maybe a prepare_idle() operation should
be added to the firmware interface for this purpose?
