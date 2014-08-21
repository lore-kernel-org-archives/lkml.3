Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaHUNL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:11:57 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14283 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaHUNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:11:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Aug 2014 06:02:13 -0700
Message-ID: <53F5F019.10308@nvidia.com>
Date: Thu, 21 Aug 2014 16:11:53 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <wni@nvidia.com>
Subject: Re: [PATCH v2 5/5] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-6-git-send-email-mperttunen@nvidia.com> <53F5042A.7020603@wwwdotorg.org>
In-Reply-To: <53F5042A.7020603@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/14 23:25, Stephen Warren wrote:
> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
>> This adds a device tree controlled option to enable PMC-based
>> thermal reset in overheating situations. Thermtrip is supported on
>> Tegra30, Tegra114 and Tegra124. The thermal reset only works when
>> the thermal sensors are calibrated, so a soctherm driver is also
>> required.
>
> If calibration is required, presumably the soctherm must initialize
> before this thermtrip code can initialize, or this thermtrip logic might
> be triggered by uncalibrated sensors?

SOCTHERM requires that each sensor be explicitly enabled before it gives 
readings. If a sensor is not enabled, the temperature given by the 
register (and used to trigger thermtrip) will be zero. So in order for a 
thermtrip shutdown to be caused before soctherm is initialized, the 
thermtrip temperature would have to be programmed to below zero (the 
default value is 105C), in which case an immediate shutdown would 
probably be in order anyway (unless the user uses LN2 or something to 
cool the soc below zero).

>
> If so, then there needs to be some explicit mechanism to force the two
> drivers into probing in the right order.

Because of the above, I think it isn't necessary to probe these in order.

Cheers,
Mikko
