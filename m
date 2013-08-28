Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3H1Mts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:49:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5496 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3H1Mtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:49:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 05:49:46 -0700
Message-ID: <521DF1E9.7050504@nvidia.com>
Date: Wed, 28 Aug 2013 15:49:45 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] ARM: tegra: Add hdmi to Tegra114 Dalmore device tree
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com> <1377686459-16634-6-git-send-email-mperttunen@nvidia.com> <20130828123008.GC32254@ulmo>
In-Reply-To: <20130828123008.GC32254@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 03:30 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Aug 28, 2013 at 01:40:59PM +0300, Mikko Perttunen wrote:
>> Add hdmi node to Dalmore device tree to supply Dalmore-specific
>
> s/hdmi/HDMI/

Will fix.

>
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> [...]
>> +	host1x {
>> +		hdmi {
>> +			status = "okay";
>> +
>> +			vdd-supply = <&vdd_hdmi_reg>;
>> +			pll-supply = <&palmas_smps3_reg>;
>> +			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
>
> I prefer to use a blank line to separate "standard" from
> "vendor-specific" properties.

Will fix.

>
>> +			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
>
> Other .dts files split this so it doesn't exceed 80 characters. I'm not
> sure how useful that is as a general rule for DT source files, though.

Will fix. I guess check_patch.pl doesn't check for line length in *.dts.

>
>>   	i2c@7000d000 {
>>   		status = "okay";
>>   		clock-frequency = <400000>;
>> @@ -1169,6 +1184,8 @@
>>   			regulator-min-microvolt = <5000000>;
>>   			regulator-max-microvolt = <5000000>;
>>   			enable-active-high;
>> +			regulator-always-on;
>> +			regulator-boot-on;
>
> This warrants at least a mention in the commit message.

Hmm, yeah. Looks like the HDMI driver only enables the Vdd in 
tegra_output_hdmi_enable, which is too late at least for DDC. I guess a 
better patch would be to enable it earlier. In _probe?

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>
