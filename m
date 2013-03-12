Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3CLPcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:32:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57822 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3CLPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:32:52 -0400
Message-ID: <513F4A3B.7080806@ti.com>
Date: Tue, 12 Mar 2013 16:31:07 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, cpufreq <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: cpufreq-cpu0: provide compatibility string
 for DT matchup
References: <1363043130-30270-1-git-send-email-nm@ti.com> <1363043130-30270-3-git-send-email-nm@ti.com> <513EB7FE.1070000@ti.com> <513F3B98.6050909@ti.com> <20130312144334.GB21599@kahuna>
In-Reply-To: <20130312144334.GB21599@kahuna>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 03:43 PM, Nishanth Menon wrote:
> On 15:28-20130312, Benoit Cousson wrote:
>> On 03/12/2013 06:07 AM, Santosh Shilimkar wrote:
>>> On Tuesday 12 March 2013 04:35 AM, Nishanth Menon wrote:
>>>> commit 5553f9e (cpufreq: instantiate cpufreq-cpu0 as a platform_driver)
>>>> now forces platform device to be registered for allowing cpufreq-cpu0
>>>> to be used by SoCs. example: drivers/cpufreq/highbank-cpufreq.c
>>>>
>>>> However, for SoCs that wish to link up using device tree, instead
>>>> of platform device, provide compatibility string match:
>>>> compatible = "cpufreq,cpu0";
>>
>> You cannot add a non-HW relative binding... DT is supposed to represent
>> the pure HW.
>> AFAIK, cpufreq has nothing to do with the HW definition.
> Ref:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/cpufreq/highbank-cpufreq.c#n61
> there is a need for a device of some sort.  in the example above, we
> register a dummy device for linking up with cpufreq-cpu0 driver.
> what we do in this patch is to indicate that SoC CPUs are managed by
> cpufreq-cpu0 driver.
> 
> I am a bit curious to see how else would we represent drivers to manage
> real h/w devices like CPU? Is the highbank style the recommended way to do
> things?

Yep, I don't think this is a very elegant way to do that, but until we
do have a generic DVFS layer, I'm not sure we have any other approach.
But maybe not.

The CPU is the real device, but AFAIK, nobody beside OMAP is
representing the CPU as the device.
But I'd rather use a CPU device than a fake CPUFREQ device.

Regards,
Benoit
