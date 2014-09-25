Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaIYPri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:47:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45796 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:47:37 -0400
Message-ID: <54243931.6050804@wwwdotorg.org>
Date: Thu, 25 Sep 2014 09:48:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sjoerd Simons <sjoerd@luon.net>, Alexandre Courbot <acourbot@nvidia.com>
CC: Ben Skeggs <bskeggs@redhat.com>, Thierry Reding <thierry.reding@gmail.com>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com> <20140925132717.GA13579@dusk.luon.net>
In-Reply-To: <20140925132717.GA13579@dusk.luon.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
> Playing a bit with todays linux-next on my jetson, it seems this patch is
> still required for enabling the GPU. Is there anything blocking it (firmware
> not available yet in liux-firmware?)

I think initially I was waiting for the DRM patch "drm/nouvea: support 
for probing platform devices" to be applied, but it looks like that's 
been applied already, so only patches 4 and 5 in this series are still 
outstanding.

Alex, wasn't there also some issue where the VPR register had to be 
programmed, and if it wasn't there'd be a hang when the GPU registers 
were touched? If we've added code to Nouveau/tegradrm to detect that and 
avoid the problem, then I guess we can commit these last two patches for 
3.19. A resend after the 3.18 merge window might help.

> On Mon, May 19, 2014 at 06:24:10PM +0900, Alexandre Courbot wrote:
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   arch/arm/boot/dts/tegra124-jetson-tk1.dts | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> index e31fb61a81d3..15a194d1277f 100644
>> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>> @@ -30,6 +30,12 @@
>>   		};
>>   	};
>>
>> +	gpu@0,57000000 {
>> +		status = "okay";
>> +
>> +		vdd-supply = <&vdd_gpu>;
>> +	};
>> +
>>   	pinmux: pinmux@0,70000868 {
>>   		pinctrl-names = "default";
>>   		pinctrl-0 = <&state_default>;
>> @@ -1505,7 +1511,7 @@
>>   					regulator-always-on;
>>   				};
>>
>> -				sd6 {
>> +				vdd_gpu: sd6 {
>>   					regulator-name = "+VDD_GPU_AP";
>>   					regulator-min-microvolt = <650000>;
>>   					regulator-max-microvolt = <1200000>;
>

