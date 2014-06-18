Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbaFRJsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:48:04 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55796 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbaFRJsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:48:00 -0400
Message-ID: <53A16047.7010409@collabora.co.uk>
Date: Wed, 18 Jun 2014 11:47:51 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC regulators
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk> <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk> <20140617211747.GY29841@lee--X1>
In-Reply-To: <20140617211747.GY29841@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

Thanks a lot for your feedback.

On 06/17/2014 11:17 PM, Lee Jones wrote:
>> The MAX77802 PMIC has 10 high-efficiency Buck and 32 Low-dropout
>> (LDO) regulators. This patch adds support for all these regulators
>> found on the MAX77802 PMIC and is based on a driver added by Simon
>> Glass to the Chrome OS kernel 3.8 tree.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>> 
>> Changes since v1:
>>  - Remove unneeded check if num_regulators != MAX77802_MAX_REGULATORS.
>>  - Fix .set_suspend_mode handler comment and split regulators ops for
>>    regulators that behave differently. Suggested by Mark Brown.
>>  - Use module_platform_driver() instead of having init/exit functions.
>>    Suggested by Mark Brown.
>>  - Use the new descriptor-based GPIO interface instead of the deprecated
>>    integer based GPIO one. Suggested by Mark Brown.
>>  - Look for "regulators" child node instead of "voltage-regulators" to be
>>    consistent with other PMIC drivers. Suggested by Mark Brown.
>> 
>>  drivers/mfd/max77802.c       |   1 +
> 
> Can you remove all of the MFD changes from patches 7, 8 and 9 and
> create new one.  That way there's no requirement for any cross
> subsystem messiness.
> 

Sure, Mark already suggested the same and I'll do it on the next version.

But there still be some cross-subsystem dependency/messiness since the
regulator, clk and rtc drivers include the mfd max77802 headers that are added
in Patch 6.

So I guess you should either a) take the whole patch-set through your mfd tree
or b) merge the mfd patches and create an immutable branch that can be pulled by
Mark, Mike and Alessandro.

I don't know what's the preferred workflow in these cases...

>>  drivers/regulator/Kconfig    |   9 +
>>  drivers/regulator/Makefile   |   1 +
>>  drivers/regulator/max77802.c | 701 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 712 insertions(+)
>>  create mode 100644 drivers/regulator/max77802.c
> 

Best regards,
Javier
