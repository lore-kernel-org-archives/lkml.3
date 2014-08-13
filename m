Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaHMHwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:52:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12197 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:52:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Aug 2014 00:39:05 -0700
Message-ID: <53EB1932.9040601@nvidia.com>
Date: Wed, 13 Aug 2014 10:52:18 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: tegra: Add PMC thermtrip programming to Jetson
 TK1 device tree
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com> <1407226380-747-3-git-send-email-mperttunen@nvidia.com> <20140813073736.GB17466@ulmo>
In-Reply-To: <20140813073736.GB17466@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 10:37, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Aug 05, 2014 at 11:12:59AM +0300, Mikko Perttunen wrote:
>> This adds the required information to reset the board during an overheating
>> situation to the Jetson TK1 device tree. The thermal reset is handled by the
>> PMC by sending an I2C message to the PMIC. The entries specify the I2C
>> message to be sent.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   arch/arm/boot/dts/tegra124-jetson-tk1.dts | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> index 624b0fb..ee178c4 100644
>> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> @@ -1617,6 +1617,11 @@
>>   		nvidia,core-pwr-off-time = <61036>;
>>   		nvidia,core-power-req-active-high;
>>   		nvidia,sys-clock-req-active-high;
>> +
>> +		nvidia,thermtrip-pmu-i2c-addr = <0x40>;
>> +		nvidia,thermtrip-i2c-controller = <4>;
>> +		nvidia,thermtrip-reg-addr = <0x36>;
>> +		nvidia,thermtrip-reg-data = <0x2>;
>
> Given the number of properties that this can potentially have, I wonder
> if perhaps it would be a good idea to put this into a subnode, like
> this:
>
> 		thermtrip {
> 			pmu-i2c-addr = <0x40>;
> 			i2c-controller = <4>;
> 			...
> 		};

I guess that'd look a bit nicer.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

Mikko
