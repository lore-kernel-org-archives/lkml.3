Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaHMHvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:51:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4492 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaHMHvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:51:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Aug 2014 00:41:53 -0700
Message-ID: <53EB18E6.3070203@nvidia.com>
Date: Wed, 13 Aug 2014 10:51:02 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/3] of: Add descriptions of thermtrip properties to Tegra
 PMC bindings
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com> <1407226380-747-2-git-send-email-mperttunen@nvidia.com> <20140813073541.GA17466@ulmo>
In-Reply-To: <20140813073541.GA17466@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 10:35, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Aug 05, 2014 at 11:12:58AM +0300, Mikko Perttunen wrote:
>> Hardware-triggered thermal reset requires configuring the I2C
>> reset procedure. This configuration is read from the device tree,
>> so document the relevant properties in the binding documentation.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   .../devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt    | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
>> index 68ac65f..140e2aa 100644
>> --- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
>> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
>> @@ -38,6 +38,19 @@ Required properties when nvidia,suspend-mode is specified:
>>   			      Core power good time in uS.
>>   - nvidia,core-pwr-off-time : Core power off time in uS.
>>
>> +Required properties for hardware-triggered thermal reset:
>> +    (only tegra30, tegra114, tegra124)
>> +- nvidia,thermtrip-pmu-i2c-addr : I2C address of the power management unit.
>> +- nvidia,thermtrip-i2c-controller : Index of the I2C controller the PMU is
>> +                                    attached to.
>
> This duplicates information already associated with the PMU device. Can
> this be turned into something like:
>
> 	nvidia,thermtrip-pmu: phandle to Power Management Unit
>
> Then we can query the relevant information from the I2C client resolved
> from the phandle.

True, that would look nicer.

>
> One problem with that might be that the I2C controller index may not
> match the hardware ID.

Maybe we could resort to checking the controller address in this case. 
This is a safety feature, so programming the wrong controller index 
accidentally would be bad.

>
>> +- nvidia,thermtrip-reg-addr : Address (byte) to send reset command to.
>> +- nvidia,thermtrip-reg-data : Data (byte) to use as reset command.
>> +
>> +Optional properties for hardware-triggered thermal reset:
>> +    (only tegra30, tegra114, tegra124)
>> +- nvidia,thermtrip-pinmux : Pinmux ID used for I2C access.
>
> I suppose this takes a phandle? If so the description should probably
> say so.

No, it takes a pinmux ID, described in the boot process (non-public in 
T124 I guess..) section of the TRM. It seems, though, that all platforms 
supported by the downstream kernel have pinmux == 0.

>
>> +- nvidia,thermtrip-pmu-16bit-ops : Use 16-bit operations.
>
> What exactly does "16-bit operations" mean? And isn't this a property of
> the I2C device, therefore could be queried from the I2C slave via the
> phandle?

That's how it's described in the TRM, but I just found a comment in the 
downstream kernel about it. Apparently it controls the amount of data 
sent to the PMIC. The downstream kernel says, though, that the option is 
not supported and must always be left as zero, so I guess it could be 
dropped.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

Cheers,
Mikko
