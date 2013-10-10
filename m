Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3JJJzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:55:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48457 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3JJJzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:55:20 -0400
Message-ID: <5256796B.7070000@ti.com>
Date: Thu, 10 Oct 2013 15:24:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1381390377-11109-1-git-send-email-kishon@ti.com> <20131010093908.GD26954@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131010093908.GD26954@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 October 2013 03:09 PM, Mark Rutland wrote:
> On Thu, Oct 10, 2013 at 08:32:57AM +0100, Kishon Vijay Abraham I wrote:
>> The Palmas device contains only a USB VBUS-ID detector, so added a
>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>> types for backward compatibility.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>> Changes from v4:
>> * added compatible property "ti,twl6035-usb-vid"
>>
>> Changes from v3:
>> * Fixed commit log message (VID to VBUS-ID).
>> * Fixed the Documentation to tell "ti,twl6035-usb" and "ti,palmas-usb" is
>> deprecated
>> Changes from [1]:
>> * Since the old compatible values will be in 3.11 kernel, we shouldn't remove
>> the old compatible values. So retain the old compatible values.
>>
>> [1] -> http://www.spinics.net/lists/linux-omap/msg95843.html
>>
>>  Documentation/devicetree/bindings/extcon/extcon-palmas.txt |    4 +++-
>>  drivers/extcon/extcon-palmas.c                             |    2 ++
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>> index 7dab6a8..ce2100f 100644
>> --- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>> +++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>> @@ -2,7 +2,9 @@ EXTCON FOR PALMAS/TWL CHIPS
>>  
>>  PALMAS USB COMPARATOR
>>  Required Properties:
>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>> + - compatible : Should be "ti,palmas-usb-vid" or "ti,twl6035-usb-vid".
>> +   "ti,twl6035-usb" and "ti,palmas-usb" is deprecated and is kept
>> +   for backward compatibility.
> 
> How about having these one per line, with a description:
> 
> - compatible: should contain one of:
>   * "ti,palmas-usb-vid" for palmas systems. 
>   * "ti,twl6035-usb-vid" for twl6035 systems.
>   * "ti,palmas-usb" (DEPRECATED - use "ti,palmas-usb-vid").
>   * "ti,twl6035-usb" (DEPRECATED - use "ti,twl6035-usb-vid").
> 
> That makes it easier to add to in future, and hopefully makes things a
> bit clearer.
> 
> I don't think we need to state it's kept for backwards compatiblity.
> The set of strings Linux understands is a Linux detail rather than a dt
> detail.
> 
>>  
>>  Optional Properties:
>>   - ti,wakeup : To enable the wakeup comparator in probe
>> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
>> index 6c91976..6e83e9a 100644
>> --- a/drivers/extcon/extcon-palmas.c
>> +++ b/drivers/extcon/extcon-palmas.c
>> @@ -269,7 +269,9 @@ static const struct dev_pm_ops palmas_pm_ops = {
>>  
>>  static struct of_device_id of_palmas_match_tbl[] = {
>>  	{ .compatible = "ti,palmas-usb", },
>> +	{ .compatible = "ti,palmas-usb-vid", },
>>  	{ .compatible = "ti,twl6035-usb", },
>> +	{ .compatible = "ti,twl6035-usb-vid", },
> 
> It might be worth a /* DEPRECATED */ note on the old strings.
> 
> Otherwise, the looks sensible to me.

Ok. I'll change it in the next version.

Thanks
Kishon
