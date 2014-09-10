Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaIJSVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:21:18 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43654 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIJSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <54108AE7.8020600@gmail.com>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
	<541071CF.9030901@gmail.com>
	<CAJ5Y-eYRiq8ZFuKQHR0cDBWQfp7eEQLVfzvXNHpxOwEFQZeEeg@mail.gmail.com>
	<54108AE7.8020600@gmail.com>
Date: Wed, 10 Sep 2014 14:21:15 -0400
Message-ID: <CAJ5Y-eaKeyfF8hyN3fqoKEOH-+Z8ubogGFNtsKG3g75g9qnOWA@mail.gmail.com>
Subject: Re: [RFC v1 0/6] CPPC as a PID backend
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "rwells@codeaurora.org" <rwells@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 13:31, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> On 09/10/2014 09:11 AM, Ashwin Chaugule wrote:
>> On 10 September 2014 11:44, Dirk Brandewie <dirk.brandewie@gmail.com>
>> With the current split I think you will still be able to maintain
>> Intel specific changes for the future in the backend driver. The PID
>> algorithm seems platform independent anyway and the PID knobs are
>> exported to userspace for platform specific tuning. The Intel backend
>> driver should be unaffected by the CPPC (ACPI) backend. We can also
>> make them mutually exclusive at runtime.
>
>
> We could make it runtime selectable whether to use CPPC or the
> native mechanisms for P state enumeration and selection but we would
> get into an awful black/white list situation that would not make
> anyone happy.
>
> Using CPPC on Intel platforms implies using HWP which is already
> planned for in intel_pstate.  I am not aware of any effort to support
> CPPC on Intel platforms that do not support HWP.  For Intel platforms
> using CPPC is NOT needed or desirable IMHO.  We had many conversations
> over many months while CPPC was being defined and made the decision
> to not use this mechanism on Intel Linux platforms.

Ok. There is no intention to force CPPC usage on Intel platforms. We
could make the CPPC backend unavailable on Intel platforms at compile
time. The idea behind this patchset is to mainly separate out the PID
algorithm so it can be used by anyone who can support it, with or
without CPPC. For ARM64 , using CPPC is useful to unify all the ARM
implementations which choose to design counters as either memory
mapped or sysregs or whatever, while keeping the PID algorithm the
same.

>>
>> Or are you suggesting using PID + CPPC as another driver? IIUC, that
>> would lead to a lot of redundancy.
>>
>
> The redundancy is actually pretty small IMHO if you take out the
> enumeration/init code the code shared at runtime is pretty small
> sample/calc_busy/PID.

This is exactly all there is in pid_ctrl.c. If HWP is enabled, do you
plan to modify these generic PID bits in a platform specific manner?
If not, then it seems that the HWP accessors could live in the intel
pid backend driver?

Cheers,
Ashwin
