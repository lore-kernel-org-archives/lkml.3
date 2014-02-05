Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaBEQ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:28:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50003 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaBEQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:28:22 -0500
Message-ID: <52F266A2.1030503@wwwdotorg.org>
Date: Wed, 05 Feb 2014 09:28:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] ARM: tegra: cpuidle: use firmware call for power
 down
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com> <1390299016-14105-6-git-send-email-acourbot@nvidia.com> <52E02DCC.1000404@wwwdotorg.org> <CAAVeFuKLtC62+bujY4724hMV_6M8Ow0s=6zRn_M87VX4PHQgxA@mail.gmail.com>
In-Reply-To: <CAAVeFuKLtC62+bujY4724hMV_6M8Ow0s=6zRn_M87VX4PHQgxA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:39 AM, Alexandre Courbot wrote:
> On Thu, Jan 23, 2014 at 5:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
>>> Invoke the do_idle() firmware call before suspending a CPU so that the
>>> underlying firmware (if any) can take necessary action.
>>
>>> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
>>
>>> @@ -45,6 +46,8 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>>>
>>>       clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>>>
>>> +     call_firmware_op(do_idle);
>>> +
>>>       cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>>>
>>>       clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>>
>> Don't you need to have the kernel also *not* do something when entering
>> idle; doesn't the FW op replace some of the register writes that the
>> kernel would otherwise be doing?
> 
> It seems like the operation is actually to inform the firmware that we
> are going to suspend the CPU. Downstream kernel also uses it that way.
> But you are right in that we should expect do_idle() to actually
> perform the suspend operation. Maybe a prepare_idle() operation should
> be added to the firmware interface for this purpose?

That sounds like a reasonable change. Is it easy to plumb in?

