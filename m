Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaKXOqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:46:39 -0500
Received: from 9.mo68.mail-out.ovh.net ([46.105.78.111]:41493 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754663AbaKXOqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:46:37 -0500
X-Greylist: delayed 16202 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 09:46:36 EST
MIME-Version: 1.0
In-Reply-To: <545CFAF4.8030104@traphandler.com>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
	<20141107115225.72bc6cbf@gandalf.local.home>
	<545CFAF4.8030104@traphandler.com>
Date: Mon, 24 Nov 2014 10:59:24 +0100
Message-ID: <CACh+v5MDFZj+NOPWdnMgNthn_DxL3nn=CZJ224vMh7hSf84o4Q@mail.gmail.com>
Subject: Re: [PATCH] arm: ftrace: Adds support for ftrace operations
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Steven Rostedt <rostedt@goodmis.org>, jslaby@suse.cz
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, nsekhar@ti.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo@redhat.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 106960491652732952
X-Ovh-Remote: 209.85.217.177 (mail-lb0-f177.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-07 18:01 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
>
>
> On 11/07/2014 05:52 PM, Steven Rostedt wrote:
>> On Fri,  7 Nov 2014 15:59:11 +0100
>> Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
>>
>>> Hi all,
>>>
>>> This patch adds support for ftrace operations on the ARM architecture.
>>> This support is needed by kgraft and possibly other ftrace-based tools.
>>> My goal is to have kgraft working on ARM and aarch64.
>>
>> Can you add this to the change log of the patch. As that would be what
>> goes into git history. Because honestly, I had no idea what you meant
>> by "ftrace operations". If I don't understand that term, how can you
>> expect anyone else to?
> I'll try to come up with a clearer commit log.
>>
>>>
>>> I tested this patch with a toy implementation of kgraft for ARM and basic
>>> usage of function and function_graph tracers
>>> It doesn't show any problem with the ftrace selftests and the tests found
>>> today in branch ftrace/testing-mystuff of linux-trace repository
>>> (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git)
>>
>> Those tests are no where near what I have. Does this code work on the
>> beagle bone white? If so, I can probably run my full suite on it.
> It should work on any arm processor, It's not platform or SOC dependent
>>
Hi Steve,
did you get a chance of running your tests suite on real hardware with
this patch? I'd be really interested in the results.

Jiri,
would you be interested in the patchs to run kgraft on ARM ? The
modifications required in kgraft core are minimal, it's mostly
architecture specific.

Jean-Jacques

>> -- Steve
>>
>>>
>>> Jean-Jacques Hiblot (1):
>>>   arm: ftrace: Adds support for ftrace operations
>>>
>>>  arch/arm/Kconfig               |  2 ++
>>>  arch/arm/include/asm/ftrace.h  |  3 ++
>>>  arch/arm/kernel/entry-common.S | 68 +++++++++++++++++++++++++++++++++++++++++-
>>>  arch/arm/kernel/ftrace.c       | 34 +++++++++++++++++++++
>>>  4 files changed, 106 insertions(+), 1 deletion(-)
>>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
