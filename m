Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbbAFP4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:56:33 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:56324 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbbAFP4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:56:31 -0500
Message-ID: <54AC05A5.5040401@kapsi.fi>
Date: Tue, 06 Jan 2015 17:56:21 +0200
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: swarren@wwwdotorg.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com, Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v5 3/3] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
References: <1420541578-27968-1-git-send-email-mikko.perttunen@kapsi.fi> <1420541578-27968-4-git-send-email-mikko.perttunen@kapsi.fi> <20150106151427.GQ31830@ulmo.nvidia.com>
In-Reply-To: <20150106151427.GQ31830@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 05:14 PM, Thierry Reding wrote:
> On Tue, Jan 06, 2015 at 12:52:58PM +0200, Mikko Perttunen wrote:
>> From: Mikko Perttunen <mperttunen@nvidia.com>
>>
>> This adds a device tree controlled option to enable PMC-based
>> thermal reset in overheating situations. Thermtrip is supported on
>> Tegra30, Tegra114 and Tegra124. The thermal reset only works when
>> the thermal sensors are calibrated, so a soctherm driver is also
>> required.
>>
>> The thermtrip event is triggered by the soctherm block, and all
>> soctherm sensors default to showing a temperature of zero Celsius
>> before they are initialized. Because of this, it is safe to initialize
>> thermtrip and soctherm in any order.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   drivers/soc/tegra/pmc.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 107 insertions(+)
>
> This looks good to me. I'm not sure if I asked before, but can this be
> tested? Can we somehow trick thermtrip into reporting a temperature that
> would trigger this?
>
> Thierry
>

Yep, you can find a program here: 
https://gist.github.com/cyndis/66126c9c176b5f94a76f

It sets the thermtrip threshold to zero degrees.

Mikko

