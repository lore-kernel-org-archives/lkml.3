Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3IKRtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:49:19 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10581 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab3IKRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:49:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Sep 2013 10:49:14 -0700
Message-ID: <5230B1CE.3090709@nvidia.com>
Date: Wed, 11 Sep 2013 23:39:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: Re: [PATCH V2] regulator: core: add support for configuring turn-on
 time through constraints
References: <1378904331-5665-1-git-send-email-ldewangan@nvidia.com> <5230A593.9010401@wwwdotorg.org> <5230AC5E.2020504@nvidia.com> <5230AC61.30904@wwwdotorg.org>
In-Reply-To: <5230AC61.30904@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 September 2013 11:16 PM, Stephen Warren wrote:
> On 09/11/2013 11:46 AM, Laxman Dewangan wrote:
>> On Wednesday 11 September 2013 10:47 PM, Stephen Warren wrote:
>>> - regulator-enable-ramp-delay: The time taken, in uSec, for the supply
>>> rail to reach the target voltage, plus/minus whatever tolerance the
>>> board design requires, once the regulator output itself has ramped up.
>>> This value is in addition to whatever built-in ramp time is inherent in
>>> the regulator's own internal design or configuration. This property
>>> describes the additional ramp time required due to board design issues
>>> such as trace capacitance and load on the supply.
>>>
>>> That's text repeats "additional" a bit, but I think describes the
>>> situation correctly?
>> I wanted to provide the absolute delay rather than additional delay on
>> top of inherit delay from device.
> I suppose that either is fine from a DT perspective. But, the regulator
> drivers already know their internal delay, so presumably driver code
> will have to take the value from DT, and subtract out whatever delay the
> driver already embodies, in order to calculate the extra delay required?
> Or, if this property is set, does the driver-specified delay just get
> ignored?

Yes, if property is available then driver-specified delay get ignored. 
Delay will be used from dt provided value.

Thanks,
Laxman


