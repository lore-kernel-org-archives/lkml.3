Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaIJRbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:31:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64615 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaIJRbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:31:22 -0400
Message-ID: <54108AE7.8020600@gmail.com>
Date: Wed, 10 Sep 2014 10:31:19 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "rwells@codeaurora.org" <rwells@codeaurora.org>
CC: dirk.brandewie@gmail.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [RFC v1 0/6] CPPC as a PID backend
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>	<541071CF.9030901@gmail.com> <CAJ5Y-eYRiq8ZFuKQHR0cDBWQfp7eEQLVfzvXNHpxOwEFQZeEeg@mail.gmail.com>
In-Reply-To: <CAJ5Y-eYRiq8ZFuKQHR0cDBWQfp7eEQLVfzvXNHpxOwEFQZeEeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 09:11 AM, Ashwin Chaugule wrote:
> On 10 September 2014 11:44, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
>> Hi Ashwin,
>
> Hi Dirk,
>
>>
>> I think the CPPC based driver should be a separate driver.
>>
>> We made the conscious decision to not use any of the ACPI mechanisms
>> to enumerate or control P state selection.  Experience over the years
>> has shown that the quality/accuracy of the BIOS/ACPI implementations
>> vary widely across OEM's and platform types from a single OEM. Features
>> that always work on a server platform from a given OEM may not work or
>> provide bad information on client platforms for example.
>>
>> Another reason for doing intel_pstate was to be able to land intel specific
>> features and fixes without breaking other architectures as the power
>> management capabilities of the platform evolve. As processors that support
>> Hardware P states (HWP) as described in section 14.4 of the current SDM
>> come into the market intel_pstate will change to not doing much other
>> than enabling HWP and providing an interface to forward user configuration
>> requests to the processor if the user chooses to enable HWP otherwise the
>> current mechanisms will be used.  This is why the intel_pstate sysfs
>> interface is the way it is to be able to map cleanly to HWP and provide
>> an abstract interface going forward.
>>
>> Having separate drivers allows the system integrator/user to select the
>> most appropriate mechanism for their system.
>>
>> --Dirk
>
> With the current split I think you will still be able to maintain
> Intel specific changes for the future in the backend driver. The PID
> algorithm seems platform independent anyway and the PID knobs are
> exported to userspace for platform specific tuning. The Intel backend
> driver should be unaffected by the CPPC (ACPI) backend. We can also
> make them mutually exclusive at runtime.

We could make it runtime selectable whether to use CPPC or the
native mechanisms for P state enumeration and selection but we would
get into an awful black/white list situation that would not make
anyone happy.

Using CPPC on Intel platforms implies using HWP which is already
planned for in intel_pstate.  I am not aware of any effort to support
CPPC on Intel platforms that do not support HWP.  For Intel platforms
using CPPC is NOT needed or desirable IMHO.  We had many conversations
over many months while CPPC was being defined and made the decision
to not use this mechanism on Intel Linux platforms.

For other platforms that plan on conforming to ACPI 5.x with respect
to P state enumeration and selection I would like to leave it to them
to hurd all the cats at the OEMs to get CPPC correct on all their platforms.

>
> Or are you suggesting using PID + CPPC as another driver? IIUC, that
> would lead to a lot of redundancy.
>

The redundancy is actually pretty small IMHO if you take out the
enumeration/init code the code shared at runtime is pretty small
sample/calc_busy/PID.


> Cheers,
> Ashwin
>

