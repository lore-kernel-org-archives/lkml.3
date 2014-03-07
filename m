Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaCGEXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:23:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCGEXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:23:41 -0500
Message-ID: <531949CB.1000904@wwwdotorg.org>
Date: Thu, 06 Mar 2014 21:23:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com> <1393932664-13319-4-git-send-email-wni@nvidia.com> <5318B790.8090808@wwwdotorg.org> <531940C5.3040102@nvidia.com>
In-Reply-To: <531940C5.3040102@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 08:45 PM, Wei Ni wrote:
> On 03/07/2014 01:59 AM, Stephen Warren wrote:
>> On 03/04/2014 04:31 AM, Wei Ni wrote:
>>> Add dt node to describe the thermal zone for the nct1008.
>>
>>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>>
>>> +	thermal-zones {
>>> +		nct1008-local {
>>> +			polling-delay-passive = <2000>; /* milliseconds */
>>> +			polling-delay = <0>; /* milliseconds */
>>
>> A delay of 0 implies that software continually polls this zone, thus
>> consuming an entire CPU. Is this really what you want?
> 
> No, if this delay is 0, the driver will not run polling queue, but just
> cancel it.

The binding doesn't say this. The DT needs to be written to the binding
as specified in the documentation, not to the behaviour of one
particular OS's driver.

Now, if the DT binding gets updated to explicitly document this, the DT
content above would be fine.
