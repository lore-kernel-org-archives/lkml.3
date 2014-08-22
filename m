Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaHVM4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:56:02 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14703 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaHVM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:56:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Aug 2014 05:42:05 -0700
Message-ID: <53F73DDC.2000303@nvidia.com>
Date: Fri, 22 Aug 2014 15:55:56 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <wni@nvidia.com>
Subject: Re: [PATCH v2 5/5] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-6-git-send-email-mperttunen@nvidia.com> <53F5042A.7020603@wwwdotorg.org> <53F5F019.10308@nvidia.com> <53F612D2.8020803@wwwdotorg.org>
In-Reply-To: <53F612D2.8020803@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/08/14 18:40, Stephen Warren wrote:
> On 08/21/2014 07:11 AM, Mikko Perttunen wrote:
>> On 20/08/14 23:25, Stephen Warren wrote:
>>> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
>>>> This adds a device tree controlled option to enable PMC-based
>>>> thermal reset in overheating situations. Thermtrip is supported on
>>>> Tegra30, Tegra114 and Tegra124. The thermal reset only works when
>>>> the thermal sensors are calibrated, so a soctherm driver is also
>>>> required.
>>>
>>> If calibration is required, presumably the soctherm must initialize
>>> before this thermtrip code can initialize, or this thermtrip logic might
>>> be triggered by uncalibrated sensors?
>>
>> SOCTHERM requires that each sensor be explicitly enabled before it gives
>> readings. If a sensor is not enabled, the temperature given by the
>> register (and used to trigger thermtrip) will be zero. So in order for a
>> thermtrip shutdown to be caused before soctherm is initialized, the
>> thermtrip temperature would have to be programmed to below zero (the
>> default value is 105C), in which case an immediate shutdown would
>> probably be in order anyway (unless the user uses LN2 or something to
>> cool the soc below zero).
>>
>>>
>>> If so, then there needs to be some explicit mechanism to force the two
>>> drivers into probing in the right order.
>>
>> Because of the above, I think it isn't necessary to probe these in order.
>
> OK, that makes sense. Briefly mentioning this in the commit description
> could be useful.
>

Sure, I'll add a mention to the next version.

Mikko
