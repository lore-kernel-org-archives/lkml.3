Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbaDXQBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:01:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55988 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbaDXQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:01:16 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-f6-53593549d93f
Message-id: <53593542.9010106@samsung.com>
Date: Thu, 24 Apr 2014 18:01:06 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Romain Naour <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v8 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
 <1397459860-21869-2-git-send-email-t.dakhran@samsung.com>
 <5617478.sn2TYu7iO3@wuerfel> <534BCD88.4020108@samsung.com>
In-reply-to: <534BCD88.4020108@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRzGefcd9m01/FyaL4MyJ0lpWoLBS6YUFH4SgSVFdpFOHSq4qVuT
	7MZpZjp16USc0zzgVFxT81CamIdlKxItFWcnh1mh6YJoQzSzctuNdz8efs//uflTGH8SF1Bp
	0ptimVSULiS5+MTfl5bg6JNxsSde3AtC2xozG2k6R1noc9d7HDWMTxHovq2JQP+W1gg0tdoO
	UFnjHIkm821s1PPFQqCmQj2OZgfrSKR9M8xCH2d5qGV+moW+lU+TqLy6A0ed36txdPfZOBv1
	bRYBtFX6C0Ndy68BMmv1AFVpN9hnIGOsNwKm4E4pyWz91gBmVl3GYrYNKxjzVLfAZtrbHCTT
	YygmmdWHNQTzyTJEMr36XGbVgjPqPgNg+i31GGPvORjjcZ17OlmcnpYtlh2PTOCmjj7SYZlj
	nFvdlY8xJbCRKsChIB0GFwvUuJv3w7fWrp2cS/HpFgBbB+pdEp+2A9jxwcfJPDoQDqm6WU7G
	6cNwaXjGVSbpAGhXLrl8jx3HmD/vyr3pa9Ca95xwdz3hRqXVlXvRmXBE2YY5xzC6hoTNtj9A
	BShqHx0FR1uPuXdHAFw1HnAyhw6C20slrjsYHQ7bNU+Am31hr/EHVg48dbsmdLs03S6tEWAG
	4C1WJGXKE1MkoSFykUSukKaEJGVIeoD7BRwDoNl8ygRoCgj38n4GxMXyCVG2PEdiApDChF68
	V0E7ES9ZlHNbLMuIlynSxXITYFEcgRIIb6zRtVqfd8orOYoKffjkoWXOlmBKp6oT6OfrI7TN
	M5uREqrE3GV/sH41Js9hij96Icc3zH/OzxRtyzJZv16GbO5cTIOq0V8tDcyysAZTjlRNJJ6t
	wPb4qWpliQmXcoPPOwqJiO7ikLCVc/yo/jGtde7iAlpkBITHOrtIiMtTRaGBmEwu+g8wMWNP
	4AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 14.04.2014 13:59, Tarek Dakhran wrote:
> On 04/14/2014 03:03 PM, Arnd Bergmann wrote:
>> On Monday 14 April 2014 11:17:38 Tarek Dakhran wrote:
>>> --- a/arch/arm/mach-exynos/exynos.c
>>> +++ b/arch/arm/mach-exynos/exynos.c
>>> @@ -159,6 +159,15 @@ static struct map_desc exynos5250_iodesc[]
>>> __initdata = {
>>>          },
>>>   };
>>> +static struct map_desc exynos5410_iodesc[] __initdata = {
>>> +       {
>>> +               .virtual        = (unsigned long)S5P_VA_SYSRAM_NS,
>>> +               .pfn            =
>>> __phys_to_pfn(EXYNOS5410_PA_SYSRAM_NS),
>>> +               .length         = SZ_4K,
>>> +               .type           = MT_DEVICE,
>>> +       },
>>> +};
>>> +
>>>   static struct map_desc exynos5_iodesc[] __initdata = {
>> NAK
>>
>> Why does this keep coming up?
>>
>>     Arnd
>>
> We need this memory region because boot address for exynos5410 located
> here, same as for 5250.
>

Is there really no way to map this region dynamically in the entity 
(driver, source file, whatever) that actually uses it? The goal is to 
get rid of all the static mappings entirely, so adding new one makes us 
further from it.

Best regards,
Tomasz
