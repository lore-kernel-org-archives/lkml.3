Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaH0RAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:00:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45644 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884AbaH0RAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:00:04 -0400
Message-ID: <53FE0E4E.7080000@ahsoftware.de>
Date: Wed, 27 Aug 2014 18:58:54 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826101107.GC32315@leverpostej> <20140827103432.64927C409CB@trevor.secretlab.ca> <20140827144403.GB13850@arm.com> <53FE05AE.9000406@wwwdotorg.org> <53FE07BE.7000809@ahsoftware.de> <53FE0966.5020206@wwwdotorg.org>
In-Reply-To: <53FE0966.5020206@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.08.2014 18:37, schrieb Stephen Warren:
> On 08/27/2014 10:30 AM, Alexander Holler wrote:
>> Am 27.08.2014 18:22, schrieb Stephen Warren:
>>> On 08/27/2014 08:44 AM, Catalin Marinas wrote:
>>
>>>> It's not just optimisation but an important feature for new arm64 SoCs.
>>>> Given some Tegra discussions recently, in many cases the machine_desc
>>>> use on arm is primarily to initialise devices in the right order. If we
>>>> can solve this in a more deterministic way (other than deferred
>>>> probing), we avoid the need for a dedicated SoC platform driver (or
>>>> machine_desc) or workarounds like different initcall levels and
>>>> explicit
>>>> DT parsing.
>>>
>>> A lot of the ordering is SW driver dependencies. I'm not sure how much
>>> of that can accurately be claimed as HW dependencies. As such, I'm not
>>> sure that putting dependencies into DT would be a good idea; it doesn't
>>> feel like HW data, and might well change if we restructure SW. It'd need
>>> some detailed research though.
>>
>> Almost every phandle is a dependency, so the DT is already full with
>> them.
>
> That's true, but not entirely relevant.
>
> phandles in DT should only be present where there's an obvious HW
> dependency. It's obvious that, for example, there's a real HW dependency
> between an IRQ controller and a device that has an IRQ signal fed into
> the IRQ controller. It makes perfect sense to represent that as a
> phandle (+args).
>
> However, most of the ordering imposed by the Tegra machine descriptor
> callbacks is nothing to do with this. It's more that the SW driver for
> component X needs some low level data (e.g. SKU/fuse information) before
> it can run. However, there's no real HW dependency between the HW
> component X and the fuse module. As such, it doesn't make sense to
> represent such a dependency in DT, using a phandle or by any other means.
>
> Of course, there are probably cases where we could/should add some more
> phandles/... and likewise cases where we shouldn't. That's why detailed
> research is needed.
>
> Irrespective though, a new kernel needs to work against an old DT, so
> always needs to work without any (of these new) dependencies being
> represented in DT, since they aren't represented there today. So, I
> think pushing the issue into DT is a non-starter either way, unless we
> accept yet another ABI-breaking change, in which case we should just
> give up on any claims of ABI and make everyone's lives simpler.

If I hear research, my response is usually "how many years"?

Fact is that there are already a lot of usable dependencies in the DT, 
they just didn't find their way into the kernel and weren't used.

And I think it doesn't help much to make the picture more complicated 
than it already is. Solve one step by another and not try to solve 
everything at once.

So first enable the kernel to use dependencies at all. I've shown that 
it doesn't need magic to do so. Afterwards you can extend or change the 
existing solution. It's not always the best approach, but for 
complicated things it often doesn't make sense trying to solve 
everything at first.

Of course, my approach isn't perfect, but at least it is something 
people can already use to play with.

Ok, the way how my patches do handle devices (not drivers) might be 
completely wrong, but that's just because I've never got in contact with 
the device-model before, it always just worked. So I haven't spend any 
time to look into that before and I didn't spend much time to look into 
that for my patches (I just discoverd that device-handling by drivers 
looks sometimes awkward). I was happy with what I've achieved in the 
short time I've spend, and therfor posted the patches to give other 
people an easy possibility to try the stuff themself.

Regards,

Alexander Holler
