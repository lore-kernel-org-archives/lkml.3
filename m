Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbbAOBJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:09:08 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59735 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbbAOBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:09:07 -0500
Message-ID: <54B7132A.6030803@gmail.com>
Date: Wed, 14 Jan 2015 17:08:58 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jonathan Richardson <jonathar@broadcom.com>, Joe Perches <joe@perches.com>
CC: devicetree@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-input@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc touchscreen
 driver
References: <Jonathan Richardson <jonathar@broadcom.com> <1419027470-7969-1-git-send-email-jonathar@broadcom.com> <1419027470-7969-2-git-send-email-jonathar@broadcom.com> <1419028015.25129.14.camel@perches.com> <5494AEB8.8060606@broadcom.com>
In-Reply-To: <5494AEB8.8060606@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 15:03, Jonathan Richardson wrote:
> On 14-12-19 02:26 PM, Joe Perches wrote:
>> On Fri, 2014-12-19 at 14:17 -0800, Jonathan Richardson wrote:
>>> Add initial version of the Broadcom touchscreen driver.
>>
>> more trivia:
>>
>>> diff --git a/drivers/input/touchscreen/bcm_iproc_tsc.c b/drivers/input/touchscreen/bcm_iproc_tsc.c
>> []
>>> +static int get_tsc_config(struct device_node *np, struct iproc_ts_priv *priv)
>>> +{
>>> +	u32 val;
>> []
>>> +	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
>>> +		if (val < 0 || val > 255) {
>>> +			dev_err(dev, "debounce_timeout must be [0-255]\n");
>>> +			return -EINVAL;
>>> +		}
>>> +		priv->cfg_params.debounce_timeout = val;

BTW, common practice for DT properties is to use a dash instead of an
underscore for multi-worded properties.

>>
>> Doesn't the compiler generate a warning message
>> about an impossible "unsigned < 0" test for all
>> of these "val < 0" uses?
>>
> 
> Actually no it doesn't. The gcc output shows that neither -Wtype-limits
> nor -Wextra are used to compile that file. I assume this is because
> there would be just too many warnings.
> 
> 
>>> +	}
>>> +
>>> +	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
>>> +		if (val < 0 || val > 11) {
>> []
>>> +	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
>>> +		if (val < 0 || val > 255) {
>> []
>>> +	if (of_property_read_u32(np, "average_data", &val) >= 0) {
>>> +		if (val < 0 || val > 8) {
>> []
>>> +	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
>>> +		if (val < 0 || val > 31) {
>>
>>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Florian
