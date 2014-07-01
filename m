Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaGAHtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:49:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17316 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaGAHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:49:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Jul 2014 00:39:36 -0700
Message-ID: <53B2681B.8020805@nvidia.com>
Date: Tue, 1 Jul 2014 10:49:47 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/6] ARM: tegra: Add soctherm and thermal zones to Tegra124
 device tree
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-5-git-send-email-mperttunen@nvidia.com> <53B1CD20.3010008@wwwdotorg.org>
In-Reply-To: <53B1CD20.3010008@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline.

On 30/06/14 23:48, Stephen Warren wrote:
> On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
>> This adds the soctherm thermal sensing and management unit to the
>> Tegra124 device tree along with the four thermal zones it exports.
>
>> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
>
>> +	thermal-zones {
>> +		cpu {
>> +			polling-delay-passive = <0>;
>> +			polling-delay = <0>;
>
> I think we should still define a polling delay so that if there's SW
> that doesn't support HW trip points/interrupts, it still knows how often
> it should reasonably check the sensor.
>
> Perhaps a delay of 0 is used to determine whether to use HW trip points
> vs polling (I haven't read patch 1 yet)? If so, I'd prefer not to do
> that. Rather, the driver should advertize its ability to provide HW trip
> points, and it would be up to the core to then make use of them. The DT
> should just describe the HW, not assume it can influence SW's choice of
> whether to use HW trip points.

Yes, a delay of 0 disables polling in the thermal core. (The hw trip 
code doesn't do anything with it) One way to fix this would be to export 
a rate changing function in the thermal core and have of-thermal set the 
polling rate to 0 or the value from device tree depending on if hw trip 
point programming succeeded or not. This would also be good for error 
handling, since if hw trip poing programming failed for whatever reason, 
we could still fall back to polling.

>
>> +	soctherm: soctherm@0,700e2000 {
> ...
>> +		reset-names = "soctherm";
>> +
>> +		#thermal-sensor-cells = <1>;
>
> I don't see any real need for that blank line. If there was, there would
> probably be more blank lines in the big list of properties above.
>

The reasoning was that #thermal-sensor-cells as a cells-property is a 
bit different from the rest, so separate them. But I can remove the 
blank line just as well.
