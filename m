Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaBZU1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:27:09 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:51658 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaBZU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <530E4B42.5090401@gmail.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net> <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org> <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com> <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Feb 2014 12:26:43 -0800
Message-ID: <CALCETrUA_JSDepFnKYsrDD5CQX65k4z_XeSxc4RxmhB2RahBZA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:14 PM, David Ahern <dsahern@gmail.com> wrote:
> On 2/26/14, 12:25 PM, Andy Lutomirski wrote:
>>
>> On Wed, Feb 26, 2014 at 11:19 AM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 2/26/14, 11:59 AM, Andy Lutomirski wrote:
>>>
>>>> I wonder if anyone who uses perf for userspace profiling *ever* uses
>>>> FP and gets away with it.  There's precious little userspace software
>>>> compiled with frame pointers these days on most architectures.
>>>
>>>
>>>
>>> yes and yes. With control over the entire stack we are making sure
>>> frame-pointers are enabled as much as possible.
>>>
>>
>> I'm curious why.
>
>
> Is there some reason not to enable frame pointers?

Speed.  FPO saves one register (a big deal on x86_32; not so important
on x86_64) but also saves a few cycles on function entry and exit,
which is a bigger deal for small functions.

>
> fp method has much less overhead than dwarf, and good, clear callchains are
> important.
>

Agreed about the good, clear callchains.  But DWARF seems to work
pretty well, and you only have the overhead when you're actually
debugging or profiling.

>
>>
>> Maybe this should be a config option.  Anyone using a standard distro
>> is running a nearly completely frame-pointer-omitted userspace these
>> days.
>
>
> Does WRL or Yocto fall into that 'standard distro' comment? Fairly easy to
> enable frame-pointers.

Fair enough :)

--Andy
