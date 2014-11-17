Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKQNYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:24:21 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:56098 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaKQNYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:24:20 -0500
Message-ID: <5469F6F8.3060102@kapsi.fi>
Date: Mon, 17 Nov 2014 15:24:08 +0200
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Lukasz Majewski <l.majewski@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing
 for tegra driver
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com> <1415898165-27406-1-git-send-email-l.majewski@samsung.com> <1415898165-27406-6-git-send-email-l.majewski@samsung.com> <5465DDC5.6090301@kapsi.fi> <20141117114341.GF25699@ulmo> <5469EF4C.1050007@kapsi.fi> <20141117130856.GB18767@ulmo>
In-Reply-To: <20141117130856.GB18767@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 03:08 PM, Thierry Reding wrote:
> On Mon, Nov 17, 2014 at 02:51:24PM +0200, Mikko Perttunen wrote:
>> On 11/17/2014 01:43 PM, Thierry Reding wrote:
>>> On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
>>>> Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
>>>>
>>>> One potential issue I can see is that if the cpufreq driver fails to probe
>>>> then you'll never get the thermal driver either. For example, Tegra124
>>>> currently has no cpufreq driver, so if CONFIG_CPU_THERMAL was enabled, then
>>>> the soctherm driver would never be able to probe. But I don't really have a
>>>> solution for this either.
>>>
>>> It doesn't seem like there's any code whatsoever to deal with cpufreq
>>> within the soctherm driver, so deferring probe based on something we're
>>> not using anyway seems rather useless.
>>>
>>> Thierry
>>>
>>
>> My understanding is that there needs to be no code inside soctherm to handle
>> it, as the cpufreq driver (cpufreq-dt) will register a cooling device that
>> will then be bound to the soctherm sensors using the of-thermal device tree
>> properties. At this moment, however, we don't have that cpufreq driver so
>> this patch is still useless for Tegra.
>
> But if the cpufreq driver will automatically do this already, why do we
> even need to check for it in the soctherm driver?
>
> Thierry
>

Indeed, we shouldn't. Unless I am mistaken, the issue is then that the 
cpufreq cooling device calls thermal_cooling_device_register before 
being ready to handle callbacks, which clearly would be an issue in the 
cpufreq driver.

The thermal core seems to able to handle registrations of thermal zones 
and cooling devices in any order; AFAICT it defers binding the tz<->cdev 
mapping until both have registered themselves to the thermal core.

Mikko

