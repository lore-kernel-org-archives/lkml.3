Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaLWB07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 20:26:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:27515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaLWB05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 20:26:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,628,1413270000"; 
   d="scan'208";a="641681264"
Message-ID: <5498C4D9.8050509@intel.com>
Date: Tue, 23 Dec 2014 09:26:49 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Zhang Rui <rui.zhang@intel.com>
CC: Olof Johansson <olof@lixom.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jg1.han@samsung.com
Subject: Re: [PATCH v6] Thermal: introduce INT3406 thermal driver
References: <54868CF6.6020505@intel.com> <CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com> <20141211010226.GA26253@aaronlu.sh.intel.com> <CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com> <1418265472.12435.68.camel@rzhang1-toshiba> <548934D0.8000502@intel.com> <1418286781.12435.73.camel@rzhang1-toshiba> <54895821.3050902@intel.com> <1419217761.19619.2.camel@rzhang1-toshiba> <20141222095344.GE4525@x1>
In-Reply-To: <20141222095344.GE4525@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 05:53 PM, Lee Jones wrote:
> On Mon, 22 Dec 2014, Zhang Rui wrote:
> 
>> On Thu, 2014-12-11 at 16:38 +0800, Aaron Lu wrote:
>>> INT3406 ACPI device object resembles an ACPI video output device, but its
>>> _BCM is said to be deprecated and should not be used. So we will make
>>> use of the raw interface to do the actual cooling. Due to this, the
>>> backlight core has some modifications. Also, to re-use some of the ACPI
>>> video module's code, one function has been exported.
>>>
>>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>>
>> Jingoo and Lee,
>>
>> are you okay with the changes in drivers/video/backlight/backlight.c and
>> include/linux/backlight.h?
> 
> NB: Jingoo still needs to review the crux of the patch.
> 
>>> ---
>>> v6: Fix an issue that wrongly set error path return value as reported
>>> by Olof Johansson.
>>>
>>>  drivers/acpi/video.c                              |  77 ++++----
>>>  drivers/thermal/Kconfig                           |  26 +--
>>>  drivers/thermal/int340x_thermal/Kconfig           |  41 ++++
>>>  drivers/thermal/int340x_thermal/Makefile          |   1 +
>>>  drivers/thermal/int340x_thermal/int3406_thermal.c | 229 ++++++++++++++++++++++
>>>  drivers/video/backlight/backlight.c               |  44 +++--
>>>  include/acpi/video.h                              |  20 ++
>>>  include/linux/backlight.h                         |   2 +
>>>  8 files changed, 366 insertions(+), 74 deletions(-)
>>>  create mode 100644 drivers/thermal/int340x_thermal/Kconfig
>>>  create mode 100644 drivers/thermal/int340x_thermal/int3406_thermal.c
> 
> I gather by the message at the top that you're looking for an Ack so
> this can be routed through another subsystem.  Not going to happen.
> 
> So you're on v6 already and a) no one has mentioned that introducing a
> new driver AND making core framework changes (in a different subsystem
> to boot) in one patch is bad and b) this is the first time you've
> Cc'ed the maintainers of the aforementioned subsystem?
> 
> Moving forward you should split this patch into component parts and
> resend -- only this time ensure you Cc all maintainers in the first
> instance, rather than as as afterthought.

OK, thanks for the suggestion.

> 
>>> -config INT340X_THERMAL
>>> -	tristate "ACPI INT340X thermal drivers"
>>> -	depends on X86 && ACPI
>>> -	select THERMAL_GOV_USER_SPACE
>>> -	select ACPI_THERMAL_REL
>>> -	select ACPI_FAN
> 
> This patch also relies on backlight as well, no?

Yes it does, will add it in next revision.

Regards,
Aaron

> 
> [...]
> 

