Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3HGScf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:32:35 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16708 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3HGScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:32:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Aug 2013 11:30:50 -0700
Message-ID: <520295F3.2020401@nvidia.com>
Date: Thu, 8 Aug 2013 00:16:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH V4] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1375871392-871-1-git-send-email-ldewangan@nvidia.com> <20130807163804.GL28558@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130807163804.GL28558@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 10:08 PM, Mark Rutland wrote:
> On Wed, Aug 07, 2013 at 11:29:52AM +0100, Laxman Dewangan wrote:
>> +Optional properties:
>> +- ti,back-battery-charge-enable: The Palmas series device like TPS65913 or
>> +	TPS80036 supports the battery backup for powering the RTC when main
>> +	battery is removed or in very low power state. This flag will enable
>> +	the backup battery charging.
> I don't like the wording here as it implies that an OS *must* charge the
> device, rather than that it *can* charge the device. How about:
>
>   - ti,backup-battery-chargeable: There is a chargeable backup battery
>                                   present.
>

The *org* property tells whether charging should be enable or not. This 
is enabled during init and it is not the runtime configuration for 
enable/disable.
By saying "backup-battery-chargeable" means it need other 
interface/calls to start charging. It does not reflect that charging 
will be enabled by default.



>> +- ti,back-battery-charge-low-current: Configure lower charging current. Device
>> +	supports the charging current as < 100mA or >100mA. Low current will
>> +	set as <100mA.
> This is somewhat unclear as it reads as a runtime configuration choice,
> rather than some instances of the device only support being changed at
> low currents (as I assume is the case?). How about:
>
>    - ti,backup-battery-low-current: The backup battery is only chargeable
>                                     at currents below 100mA.

Hmm.. I think even if battery can be charge for more than 100mA, there 
is choice of configure it for less than 100mA.

> What happens if we charge at the wrong current?
Not much sure but I think it can create battery damage.


