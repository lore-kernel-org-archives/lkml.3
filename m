Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaCGDox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:44:53 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3357 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaCGDov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:44:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Mar 2014 19:41:45 -0800
Message-ID: <531940C5.3040102@nvidia.com>
Date: Fri, 7 Mar 2014 11:45:09 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com>
 <1393932664-13319-4-git-send-email-wni@nvidia.com>
 <5318B790.8090808@wwwdotorg.org>
In-Reply-To: <5318B790.8090808@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 01:59 AM, Stephen Warren wrote:
> On 03/04/2014 04:31 AM, Wei Ni wrote:
>> Add dt node to describe the thermal zone for the nct1008.
> 
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> 
>> +	thermal-zones {
>> +		nct1008-local {
>> +			polling-delay-passive = <2000>; /* milliseconds */
>> +			polling-delay = <0>; /* milliseconds */
> 
> A delay of 0 implies that software continually polls this zone, thus
> consuming an entire CPU. Is this really what you want?

No, if this delay is 0, the driver will not run polling queue, but just
cancel it.

> 
>> +
>> +			thermal-sensors = <&nct1008 0>;
>> +		};
> 
> This zone (and the other) is missing the required (per the binding
> documentation) trips and cooling-maps sub-nodes.

Eduardo,
Are the trips and cooling-maps required properties ?
I think if miss these sub-nodes, the thermal zone device also can work,
and in the of-thermal framework, it doesn't handle them as required
property either.

> 
> I've also sent a query in response to the thermal-zones binding so see
> whether or not it can be fixed so that software doesn't bind against the
> node name, but rather against a compatible property like almost
> everything else. Let's see what the response is there before reposting
> this patch.

Sure.

Thanks.
Wei.

> 

