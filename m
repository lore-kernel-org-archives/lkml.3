Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbaFRIrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:47:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51460 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965039AbaFRIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:47:00 -0400
Message-ID: <53A15202.1070908@free-electrons.com>
Date: Wed, 18 Jun 2014 10:46:58 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v4 1/7] mfd: axp20x: add AXP221 PMIC support
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com> <1402990723-28138-2-git-send-email-boris.brezillon@free-electrons.com> <20140618083605.GQ21030@lee--X1>
In-Reply-To: <20140618083605.GQ21030@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/06/2014 10:36, Lee Jones wrote:
> On Tue, 17 Jun 2014, Boris BREZILLON wrote:
>
>> Add support for the AXP221 PMIC device to the existing AXP20x driver.
>>
>> The AXP221 defines a new set of registers, power supplies and regulators,
>> but most of the API is similar to the AXP20x ones.
>> The AXP20x irq chip definition is reused, though some interrupts are not
>> available in the AXP221.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  drivers/mfd/axp20x.c       | 64 ++++++++++++++++++++++++++++++++++++++++++----
>>  include/linux/mfd/axp20x.h | 56 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 115 insertions(+), 5 deletions(-)
> Looks good to me now.
>   Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Can this go in independently to the other patches in the set?

Yes, as long as no one define an axp221 node in his DT.
In this case axp221 regulators would be considered as axp20x ones (which
might be a bit problematic), because axp20x-regulator driver does not
test the axp variant before probing its regulators (this test is
introduced in patch 3).

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

