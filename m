Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaJHSVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:21:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaJHSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:21:00 -0400
Message-ID: <5435808A.7070203@codeaurora.org>
Date: Wed, 08 Oct 2014 11:20:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for register
 access
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com> <1412675448-11990-3-git-send-email-iivanov@mm-sol.com> <20141007172606.GG16469@dtor-ws> <1412759584.13569.0.camel@iivanov-dev> <1412760633.13569.4.camel@iivanov-dev> <54357BA7.3010609@codeaurora.org> <20141008181314.GC14423@dtor-ws>
In-Reply-To: <20141008181314.GC14423@dtor-ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Mark and Srini

On 10/08/2014 11:13 AM, Dmitry Torokhov wrote:
> On Wed, Oct 08, 2014 at 11:00:07AM -0700, Stephen Boyd wrote:
>> On 10/08/2014 02:30 AM, Ivan T. Ivanov wrote:
>>> On Wed, 2014-10-08 at 12:13 +0300, Ivan T. Ivanov wrote:
>>>> On Tue, 2014-10-07 at 10:26 -0700, Dmitry Torokhov wrote:
>>>>> Hi Ivan,
>>>>>
>>>>> On Tue, Oct 07, 2014 at 12:50:46PM +0300, Ivan T. Ivanov wrote:
>>>>>> @@ -527,10 +538,55 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>>>>> +
>>>>>> +	kp->row_hold = devm_regmap_field_alloc(kp->dev, kp->regmap,
>>>>>> +					       info->row_hold);
>>>>>> +	if (IS_ERR(kp->row_hold))
>>>>>> +		return PTR_ERR(kp->row_hold);
>>>>> Why do we have to allocate all regmap fields separately instead of
>>>>> embedding them into keypad structure?
>>>>>
>>>> No particular reason. Will rework it.
>>>>
>>> Oops. struct regmap_field is opaque. It seems that the allocation
>>> is the only way that I could have instance of it.
>>>
>> Maybe we can add an API to allocate an array of fields?
> Maybe we could make the structure public instead? I do not see any
> reason for allocating something separately that has exactly the same
> lifetime as owning structure.
>

Srini/Mark, any reason why the regmap_field structure is opaque?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

