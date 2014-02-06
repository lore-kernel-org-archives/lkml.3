Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaBFC2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 21:28:30 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6328 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbaBFC22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 21:28:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Feb 2014 18:26:28 -0800
Message-ID: <52F2F348.3000502@nvidia.com>
Date: Thu, 6 Feb 2014 11:28:24 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] ARM: tegra: cpuidle: use firmware call for power
 down
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com> <1390299016-14105-6-git-send-email-acourbot@nvidia.com> <52E02DCC.1000404@wwwdotorg.org> <CAAVeFuKLtC62+bujY4724hMV_6M8Ow0s=6zRn_M87VX4PHQgxA@mail.gmail.com> <52F266A2.1030503@wwwdotorg.org>
In-Reply-To: <52F266A2.1030503@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 01:28 AM, Stephen Warren wrote:
> On 01/23/2014 12:39 AM, Alexandre Courbot wrote:
>> On Thu, Jan 23, 2014 at 5:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
>>>> Invoke the do_idle() firmware call before suspending a CPU so that the
>>>> underlying firmware (if any) can take necessary action.
>>>
>>>> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
>>>
>>>> @@ -45,6 +46,8 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>>>>
>>>>        clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>>>>
>>>> +     call_firmware_op(do_idle);
>>>> +
>>>>        cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>>>>
>>>>        clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>>>
>>> Don't you need to have the kernel also *not* do something when entering
>>> idle; doesn't the FW op replace some of the register writes that the
>>> kernel would otherwise be doing?
>>
>> It seems like the operation is actually to inform the firmware that we
>> are going to suspend the CPU. Downstream kernel also uses it that way.
>> But you are right in that we should expect do_idle() to actually
>> perform the suspend operation. Maybe a prepare_idle() operation should
>> be added to the firmware interface for this purpose?
>
> That sounds like a reasonable change. Is it easy to plumb in?

I think so. Will post a v2 of this soon.

Thanks,
Alex.


