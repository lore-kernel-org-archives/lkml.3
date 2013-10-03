Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3JCSIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:08:05 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:62466 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3JCSIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:08:02 -0400
MIME-Version: 1.0
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514F2CE@IN01WEMBXA.internal.synopsys.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
	<C2D7FE5348E1B147BCA15975FBA2307514EA98@IN01WEMBXA.internal.synopsys.com>
	<C2D7FE5348E1B147BCA15975FBA2307514F2CE@IN01WEMBXA.internal.synopsys.com>
Date: Thu, 3 Oct 2013 13:08:00 -0500
Message-ID: <CAL_JsqJZTJwMM=noq7dDz5nhMcBGxiHgCEqxwN9BaqwZbXtbmA@mail.gmail.com>
Subject: Re: [PATCH 00/21] of: prom.h clean-up and removal
From: Rob Herring <robherring2@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 4:33 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> [Trimmed CC list a bit]
>
> On 09/27/2013 10:26 AM, Vineet Gupta wrote:
>> On 09/27/2013 12:21 AM, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> This is the second series of clean-up for architecture DT code. The first
>>> series is here [1].
>>>
>>> As the number of DT enabled architectures has grown, there has been a lot
>>> of copy/paste duplication of prom.h. The include ordering for prom.h is
>>> complex and has resulted in many implicit includes. This series cleans up
>>> prom.h and removes the dependency of prom.h includes in the core DT code
>>> on all architectures except sparc. This removes prom.h on several
>>> architectures and makes it an architecture specific include on the rest.
>>>
>>> Compiled on arm, arm64, microblaze, mips, openrisc, powerpc, sparc,
>>> xtensa. Mostly defconfigs and some allyesconfigs. The 0-day builder has
>>> also caught some issues.
>>>
>>> A branch with both series is available here:
>>> git://sources.calxeda.com/kernel/linux.git dt-cleanup
>>>
>> I gave the latest branch a spin - everything looks good except for a build warning
>> - and given the const qualifier in the API, I reckon most (if not all) would see that.
>>
>> It seems this was introduced in first series but maybe I failed to notice then as
>> I'm sure I booted that code too.
>>
>> ------------------>8-----------------------------
>>   CC      arch/arc/kernel/devtree.o
>> arch/arc/kernel/devtree.c: In function ‘setup_machine_fdt’:
>> arch/arc/kernel/devtree.c:50:8: warning: assignment discards ‘const’ qualifier
>> from pointer target type [enabled by default]
>>   mdesc = of_flat_dt_match_machine(NULL, arch_get_next_mach);
>>         ^
>> ------------------>8-----------------------------
>>
>> ARM propagates the const to callers - upto setup_arch(), but that might not work
>> for us as we use it to setup a global @machine_desc which is then used to dispatch
>> the callbacks in platform APIs. Semantically it's good if it is const but that
>> would require making it local and propagating to all the users - not worth the
>> trouble I suppose.
>>
>> What say you !
>
> Ping ?

I think this should be const like arm recently fixed. The structure is
declared const with MACHINE_START which gets dropped.

Rob
