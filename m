Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3IYN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:29:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46632 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab3IYN3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:29:43 -0400
Message-ID: <5242E51D.1020602@ti.com>
Date: Wed, 25 Sep 2013 16:29:01 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 09/15] ata: ti_sata: Add Texas Instruments SATA Wrapper
 driver
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-10-git-send-email-rogerq@ti.com> <5608096.0pgFIteLqQ@amdc1032> <3930265.gHe05HETI5@amdc1032>
In-Reply-To: <3930265.gHe05HETI5@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/25/2013 03:49 PM, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday, September 25, 2013 02:37:19 PM Bartlomiej Zolnierkiewicz wrote:
> 
> [...]
> 
>>> +#ifdef CONFIG_PM
>>> +
>>> +static int ti_sata_resume(struct device *dev)
>>> +{
>>> +	pm_runtime_disable(dev);
>>> +	pm_runtime_set_active(dev);
>>> +	pm_runtime_enable(dev);
>>
>> This doesn't look like a correct ->resume method:
>> * it shouldn't touch runtime PM at all
>> * for each ->resume method there should be a corresponding ->suspend method
>>
>> Moreover this whole wrapper driver seems strange, why not just add a proper
>> runtime PM support to ahci_platform driver instead?
> 
> Hmm, even this shouldn't be needed as this wrapper driver doesn't have
> ->runtime_suspend and ->runtime resume methods.
> 
> What exactly is the purpose of the existence of this wrapper driver?

This is the weirdness of OMAP hwmod framework :).

The OMAP hwmod framework tries to manage the module clocks by itself and needs
a runtime_resume to enable the relevant clocks.

hwmod framework will be deprecated in the near future and this is the place where
we need to handle the resources.

But since we are not yet there, I can get rid of this wrapper driver for now
and add the necessary pm_runtime calls in the ahci_platform driver.

cheers,
-roger
