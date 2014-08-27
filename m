Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaH0Nax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:30:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:45015 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933969AbaH0Naw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,411,1406617200"; 
   d="scan'208";a="473176175"
Message-ID: <53FDDD87.4030904@linux.intel.com>
Date: Wed, 27 Aug 2014 16:30:47 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Don't attempt block writes when syncing cache
 on single_rw devices
References: <1409141379-18946-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1409141379-18946-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 03:09 PM, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
>
> If the device can't support block writes then don't attempt to use raw
> syncing which will automatically generate block writes for adjacent
> registers, use the existing _single() block syncing implementation.
>
> Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>   drivers/base/regmap/regcache.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
This works too with RT5642. It appeared page select for _regmap_write() 
is actually handled implicitly for certain cases. regmap_init() sets 
"map->reg_write = _regmap_bus_raw_write" in this case and 
_regmap_bus_raw_write() then calls _regmap_raw_write(). I guess that can 
be fixed when doing other cleanups or if some setup hits it.

Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
