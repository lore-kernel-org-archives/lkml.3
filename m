Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587Ab3GaRUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:20:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42476 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3GaRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:20:10 -0400
Message-ID: <51F94744.40301@wwwdotorg.org>
Date: Wed, 31 Jul 2013 11:20:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Bill Huang <bilhuang@nvidia.com>, sameo@linux.intel.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob@landley.net, lee.jones@linaro.org,
        broonie@linaro.org, j-keerthy@ti.com, grant.likely@linaro.org,
        ian@slimlogic.co.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com> <51F8FBC4.1040009@ti.com>
In-Reply-To: <51F8FBC4.1040009@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 05:57 AM, Nishanth Menon wrote:
> On 07/31/2013 02:17 AM, Bill Huang wrote:
>> Hook up "pm_power_off" to palmas power off routine if there is DT
>> property "ti,system-power-controller" defined, so platform which is
>> powered by this regulator can be powered off properly.
>>
>> Based on work by:
>> Mallikarjun Kasoju <mkasoju@nvidia.com>
>>
>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
>> ---
>>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
>>   drivers/mfd/palmas.c                               |   33
>> ++++++++++++++++++--
> 
> Since the specific question on v1 was not answered, I will ask again,
> any reason why it wont fit in drivers/power/reset/ is'nt it the right
> place to add this?

I think it makes sense to put simple standalone reset drivers into
drivers/power/reset. However, where reset is just one tiny function of a
larger device that already has a driver, it's fine for one driver to
implement multiple features or essentially expose multiple subsystems.

(besides this is system power off not system reset; which is
drivers/power/reset?)
