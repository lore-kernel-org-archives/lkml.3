Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaHMNeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:34:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38861 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaHMNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:34:19 -0400
Message-ID: <53EB6954.3040207@collabora.co.uk>
Date: Wed, 13 Aug 2014 15:34:12 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk> <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk> <20140812172552.GU17528@sirena.org.uk> <53EA61B9.2070805@collabora.co.uk> <20140812212757.GY17528@sirena.org.uk> <53EB4CA0.3010006@collabora.co.uk> <20140813122910.GQ17528@sirena.org.uk>
In-Reply-To: <20140813122910.GQ17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 02:29 PM, Mark Brown wrote:
> 
> Please fix your mailer to word wrap at less than 80 columns, it makes
> your mails very hard to read when replying.
> 

Sorry I had my wrap length configured to 80 but just changed to 74 now.

>> On 08/12/2014 11:27 PM, Mark Brown wrote:
> 
> No, that makes no sense.  If the voltage isn't allowed to change why
> should the constraints be specifying a range of voltages for it to be
> set to, especially a range with more than one value in it?
> 
> Please try to think about what you're doing in design terms rather than
> just bashing on things until you get something that works in your use
> case, it's important that things are understandable so that we avoid
> fragility and special casing.
> 
>> For fixed regulators (like fet4), mmc_regulator_set_ocr() just skips >> varying the regulator voltage but still expects to be able to obtain
>> its voltage.
> 
> Which can be done with regulator_get_voltage().
> 

Indeed. I'll change mmc_regulator_get_ocrmask() in MMC core then to use
regulator_can_change_voltage() to detect if the regulator is a fixed one
and call regulator_get_voltage() instead of list_voltage() in that case.

Do you agree that this is the correct solution?

Best regards,
Javier
