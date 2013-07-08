Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab3GHHfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:35:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4976 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3GHHff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:35:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Jul 2013 00:36:35 -0700
Message-ID: <51DA6BD4.1040300@nvidia.com>
Date: Mon, 8 Jul 2013 15:35:48 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Alex Courbot <acourbot@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for lm90
References: <1372928979-26938-1-git-send-email-wni@nvidia.com> <1372928979-26938-2-git-send-email-wni@nvidia.com> <51D70483.70203@wwwdotorg.org>
In-Reply-To: <51D70483.70203@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 01:38 AM, Stephen Warren wrote:
> On 07/04/2013 03:09 AM, Wei Ni wrote:
>> Enable thermal sensor lm90 for t30 cardhu.
> 
>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> 
>> +		nct1008: nct1008 {
>> +			compatible = "lm90,nct1008";
> 
> "lm90" isn't a valid vendor prefix. I believe the value you want is
> "onnn,nct1008". Same comment for patch 2/2.
> 
The lm90 doesn't support device tree very well. In the DT, we need to
named as "lm90" so that the lm90 driver can be loaded, and we also need
to add "nct1008" to indicate this is the nct1008 device, so that the
lm90 driver can be loaded with the right i2c_device_id->driver_data.

I set the " compatible = "lm90,nct1008" ", this is the simplest way, and
we doesn't need to change the lm90.c.

Thanks.
Wei.
