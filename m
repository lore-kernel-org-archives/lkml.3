Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaGKHmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:42:04 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:19829 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaGKHl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:41:59 -0400
Message-ID: <53BF953C.7030109@free.fr>
Date: Fri, 11 Jul 2014 09:41:48 +0200
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, Ken Adams <KAdams@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 0/3] drm/gk20a: support for reclocking
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com> <53BE61D9.4020202@nvidia.com> <53BF4102.6010807@nvidia.com>
In-Reply-To: <53BF4102.6010807@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 03:42, Alexandre Courbot wrote:
> On 07/10/2014 06:50 PM, Mikko Perttunen wrote:
>> Does GK20A itself have any kind of thermal protection capabilities?
>> Upstream SOCTHERM support is not yet available (though I have a driver
>> in my tree), so we are thinking of disabling CPU DVFS on boards that
>> don't have always-on active cooling for now. Same might be necessary for
>> GPU as well.
>
> There is a small thermal driver ( 
> https://android.googlesource.com/kernel/tegra/+/b445e5296764d18861a6450f6851f25b9ca59dee/drivers/video/tegra/host/gk20a/therm_gk20a.c 
> ) but it doesn't seem to do much. I believe that for Tegra we rely in 
> SOCTHERM instead, but maybe Ken could confirm?

Unless it changed a great deal, I reverse engineered most of the 
registers in this area (for the nv50), but some stuff didn't change that 
much and could be used straight away (temperature reading, sending IRQs 
on thresholds, auto downclocking when overheating). We are not really 
using those features on nouveau right now, we just poll on the 
temperature every second.

If we are moving to using the PMU for thermal monitoring, we can do the 
polling there and warn the userspace when the temperature is too high or 
if performance is insufficient / too much. I have part of the code for 
performance counters in PMU, it's dead simple.

Martin
