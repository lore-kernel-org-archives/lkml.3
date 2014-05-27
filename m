Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaE0Uhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:37:55 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59478 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaE0Uhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:37:53 -0400
Message-ID: <5384F79C.6000204@gmail.com>
Date: Tue, 27 May 2014 22:37:48 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@gmail.com>, Kevin Hilman <khilman@linaro.org>
CC: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>	<7hr43f9mmn.fsf@paris.lan>	<7hd2ez9kvr.fsf@paris.lan> <CANhyOUcGTbbQLxYWsAZG00ENSDa4pj+MP2i7Rx=PfyqN1CY6WQ@mail.gmail.com>
In-Reply-To: <CANhyOUcGTbbQLxYWsAZG00ENSDa4pj+MP2i7Rx=PfyqN1CY6WQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2014 22:17, Tarek Dakhran wrote:
> Hi,
> 
> On Tue, May 27, 2014 at 9:44 PM, Kevin Hilman <khilman@linaro.org> wrote:
>> Kevin Hilman <khilman@linaro.org> writes:
>>
>>> Tarek Dakhran <t.dakhran@samsung.com> writes:
>>>
>>>> The series of patches represent support of Exynos 5410 SoC
>>>>
>>>> The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture
>>>>
>>>> Patches add new platform description, support of clock controller and device
>>>> tree for Exynos 5410.
>>>>
>>>> Has been build on Samsung Linux Kernel
>>>>   (branch: for-next, commit: 97eae6c Merge branch 'v3.16-next/multiplatform' into for-next)
>>>>
>>>> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
>>>>                  2) Exynos 5410 reference board (multi_v7_defconfig)
>>>>                  3) Odroid-XU board (exynos_defconfig)
>>>>                  4) Odroid-XU board (multi_v7_defconfig)
>>>
>>> Tested-by: Kevin Hilman <khilman@linaro.org>
>>>
>>> FYI, I boot tested this on an odroid-xu (exynos_defconfig and
>>> multi_v7_defconfig.)
>>
>> Oops, I may have spoke to soon.  There seem to be some problems with
>> multi_v7_defconfig.
>>
>> Applying this series directly on the commit mentioned above and testing,
>> it works just fine using multi_v7_defconfig.
> 
> Thank you for testing.
> 
>> However, if I directly test the current contents of the samsung for-next
>> branch (where this series has been merged) it no longer boots on the
>> odroid-xu.
>> A quick diff shows that there are some other changes to
>> multi_v7_defconfig in the samsung/for-next branch that may be causing
>> problems here.
> 
> Yes. Right you are. There is no ARCH_EXYNOS defined in multi_v7_defconfig
> at current state (branch: for-next commit: ca610da Merge branch
> 'v3.16-next/dt-samsung-3' into for-next).
> So booting kernel on 5410 SoC is not possible with multi_v7_defconfig.
> Please use exynos_defconfig.

I wonder if this patch isn't maybe the missing part:

http://thread.gmane.org/gmane.linux.kernel.samsung-soc/32414

Olof asked Kukjin to separate it from his pull requests, so it can be
applied directly to ARM SoC tree to avoid conflicts.

Best regards,
Tomasz
