Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbaJ2RZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:25:29 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56171 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934213AbaJ2RZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <5451201C.9090106@imgtec.com>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
	<1414541562-10076-3-git-send-email-abrestic@chromium.org>
	<5450B1B1.5070301@imgtec.com>
	<CAL1qeaFeoKFbea7eiiXaw87PYUWO1JmP5xxdLLpW2RrFCprtZg@mail.gmail.com>
	<5451201C.9090106@imgtec.com>
Date: Wed, 29 Oct 2014 10:25:27 -0700
X-Google-Sender-Auth: RzLYAdF_FXrjFSKL8bRiPcUGvSU
Message-ID: <CAL1qeaEOifj-R2vcWzzh2i5S3ogBf3eZ4X8PbVa1j_BtsgFCwA@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
From: Andrew Bresticker <abrestic@chromium.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul <Paul.Burton@imgtec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:13 AM, James Hogan <james.hogan@imgtec.com> wrote:
> On 29/10/14 16:55, Andrew Bresticker wrote:
>> Hi James,
>>
>> On Wed, Oct 29, 2014 at 2:21 AM, James Hogan <james.hogan@imgtec.com> wrote:
>>> Hi Andrew,
>>>
>>> On 29/10/14 00:12, Andrew Bresticker wrote:
>>>>  - changed compatible string to include CPU version
>>>
>>>> +Required properties:
>>>> +- compatible : Should be "mti,<cpu>-gic".  Supported variants:
>>>> +  - "mti,interaptiv-gic"
>>>
>>>> +Required properties for timer sub-node:
>>>> +- compatible : Should be "mti,<cpu>-gic-timer".  Supported variants:
>>>> +  - "mti,interaptiv-gic-timer"
>>>
>>> Erm, I'm a bit confused...
>>> Why do you include the core name in the compatible string?
>>>
>>> You seem to be suggesting that:
>>>
>>> 1) The GIC/timer drivers need to know what core they're running on.
>>>
>>> Is that really true?
>>
>> They don't now, but it's possible that a future CPU has a newer
>> revision of the GIC which has some differences that need to be
>> accounted for in the driver.
>>
>>> 2) It isn't possible to probe the core type.
>>>
>>> But the kernel already knows this, so what's wrong with using
>>> current_cpu_type() like everything else that needs to know?
>>>
>>> 3) Every new core should require a new compatible string to be added
>>> before the GIC will work. You don't even have a generic compatible
>>> string that DT can specify after the core specific one as a fallback.
>>
>> Yes, adding a generic compatible string would be a good idea.
>>
>>> Please lets not do this unless it's actually necessary (which AFAICT it
>>> really isn't).
>>
>> The point of this was to future-proof these bindings and I though that
>> CPU type was the best way to indicate version in the compatible
>> string.  This is also how it's done for the ARM GIC and arch timers.
>> Perhaps the best thing to do is to require both a core-specific
>> ("mti,interaptiv-gic") and generic ("mti,gic") compatible string and
>> just match on the generic one for now until there's a need to use the
>> core-specific one.  Thoughts?
>
> FPGA boards like Malta are something else to consider (when it is
> eventually converted to DT - Paul on CC knows more than me). You might
> load an interAptiv, or a proAptiv, or a P5600 bitstream, and the gic
> setup will be pretty much the same I think, since e.g. the address
> depends on where it is convenient to put it in the address space of the
> platform.

Ah, I didn't realize that the CPU bitstream could be changed
independently of the GIC.
In that case, the CPU revision isn't that useful.

> Any thoughts on the existence of current_cpu_type(), and the GIC
> revision register? They pretty much make encoding of core in compatible
> string redundant I think.

Ok, I suppose using the revision register is fine then.
