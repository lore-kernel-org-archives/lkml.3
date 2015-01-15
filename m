Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbbAOTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:19:25 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41164 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbAOTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:19:23 -0500
X-IronPort-AV: E=Sophos;i="5.09,405,1418112000"; 
   d="scan'208";a="54904519"
Message-ID: <54B812B9.3040400@broadcom.com>
Date: Thu, 15 Jan 2015 11:19:21 -0800
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Joe Perches <joe@perches.com>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-input@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc touchscreen
 driver
References: <Jonathan Richardson <jonathar@broadcom.com> <1419027470-7969-1-git-send-email-jonathar@broadcom.com> <1419027470-7969-2-git-send-email-jonathar@broadcom.com> <1419028015.25129.14.camel@perches.com> <5494AEB8.8060606@broadcom.com> <54B7132A.6030803@gmail.com>
In-Reply-To: <54B7132A.6030803@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-01-14 05:08 PM, Florian Fainelli wrote:
> On 19/12/14 15:03, Jonathan Richardson wrote:
>> On 14-12-19 02:26 PM, Joe Perches wrote:
>>> On Fri, 2014-12-19 at 14:17 -0800, Jonathan Richardson wrote:
>>>> Add initial version of the Broadcom touchscreen driver.
>>>
>>> more trivia:
>>>
>>>> diff --git a/drivers/input/touchscreen/bcm_iproc_tsc.c b/drivers/input/touchscreen/bcm_iproc_tsc.c
>>> []
>>>> +static int get_tsc_config(struct device_node *np, struct iproc_ts_priv *priv)
>>>> +{
>>>> +	u32 val;
>>> []
>>>> +	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
>>>> +		if (val < 0 || val > 255) {
>>>> +			dev_err(dev, "debounce_timeout must be [0-255]\n");
>>>> +			return -EINVAL;
>>>> +		}
>>>> +		priv->cfg_params.debounce_timeout = val;
> 
> BTW, common practice for DT properties is to use a dash instead of an
> underscore for multi-worded properties.

ts-rotation is done that way already so I'll change the others to be
consistent. Thanks.

> 
>>>
>>> Doesn't the compiler generate a warning message
>>> about an impossible "unsigned < 0" test for all
>>> of these "val < 0" uses?
>>>
>>
>> Actually no it doesn't. The gcc output shows that neither -Wtype-limits
>> nor -Wextra are used to compile that file. I assume this is because
>> there would be just too many warnings.
>>
>>
>>>> +	}
>>>> +
>>>> +	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
>>>> +		if (val < 0 || val > 11) {
>>> []
>>>> +	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
>>>> +		if (val < 0 || val > 255) {
>>> []
>>>> +	if (of_property_read_u32(np, "average_data", &val) >= 0) {
>>>> +		if (val < 0 || val > 8) {
>>> []
>>>> +	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
>>>> +		if (val < 0 || val > 31) {
>>>
>>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 
> 

