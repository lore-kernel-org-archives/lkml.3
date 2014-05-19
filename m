Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaESLJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:09:46 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61306 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaESLJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:09:45 -0400
Message-ID: <5379E66E.7020804@gmail.com>
Date: Mon, 19 May 2014 13:09:34 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Amit Kachhap <amit.kachhap@gmail.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] thermal: exynos: various cleanups
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com> <1400144805.2273.34.camel@rzhang1-toshiba> <CADGdYn5S67Sd8ON5YHiUvqiw7ypXqV3n4VURheEJsStWinR85w@mail.gmail.com> <4899668.1WyrreGo3H@amdc1032>
In-Reply-To: <4899668.1WyrreGo3H@amdc1032>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19.05.2014 13:05, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday, May 19, 2014 11:46:10 AM Amit Kachhap wrote:
>> On 5/15/14, Zhang Rui <rui.zhang@intel.com> wrote:
>>> On 一, 2014-05-05 at 13:15 +0200, Bartlomiej Zolnierkiewicz wrote:
>>>> Hi,
>>>>
>>>> This patch series contains various cleanups for EXYNOS thermal
>>>> driver.  Overall it decreases driver's LOC by 13%.  It is based
>>>> on next-20140428 kernel.  It should not cause any functionality
>>>> changes.
>>>>
>>> Amit,
>>>
>>> what do you think of this patch set?
>>>
>>> thanks,
>>> rui
>>
>> I agreed to many of the cleanups in the patch but tmu controller
>> features should be retained as they will allow adding quick soc
>> support and also avoid unnecessary churning of code in the future.
> 
> The general rule in the kernel code is not to keep the dead code as
> it has a maintainance cost and makes further changes usually more
> difficult, not easier.  There is no guarantee that the future SoCs
> support will use the dead code (i.e. TYPE_TWO_POINT_TRIMMING support
> has been introudced more than 2.5 years but no users of it has been
> ever added) and in the meantime all other code changes has to take
> the dead code into account.  I also have more Exynos thermal driver
> changes in the work and it would be much easier to do them without
> the need to support unused SoC features.  Please consider this in
> your opinion.

I'd also like to add that I don't see any correlation with mentioned
dead code and possibility of adding new SoCs. The code is mostly related
to unused/untested features and support for new SoCs might just be added
without those optional features. Moreover, less features (especially
untested) means less hassle to add new SoC, because you have less things
to test. Especially considering the fact that you would have to test
originally untested code and fix it if it turns out to be broken.

Best regards,
Tomasz
