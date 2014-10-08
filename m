Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaJHSAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:00:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59040 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJHSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:00:09 -0400
Message-ID: <54357BA7.3010609@codeaurora.org>
Date: Wed, 08 Oct 2014 11:00:07 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for register
 access
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>  <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>  <20141007172606.GG16469@dtor-ws> <1412759584.13569.0.camel@iivanov-dev> <1412760633.13569.4.camel@iivanov-dev>
In-Reply-To: <1412760633.13569.4.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 02:30 AM, Ivan T. Ivanov wrote:
> On Wed, 2014-10-08 at 12:13 +0300, Ivan T. Ivanov wrote:
>> On Tue, 2014-10-07 at 10:26 -0700, Dmitry Torokhov wrote:
>>> Hi Ivan,
>>>
>>> On Tue, Oct 07, 2014 at 12:50:46PM +0300, Ivan T. Ivanov wrote:
>>>> @@ -527,10 +538,55 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>>>   
>>>> +
>>>> +	kp->row_hold = devm_regmap_field_alloc(kp->dev, kp->regmap,
>>>> +					       info->row_hold);
>>>> +	if (IS_ERR(kp->row_hold))
>>>> +		return PTR_ERR(kp->row_hold);
>>> Why do we have to allocate all regmap fields separately instead of
>>> embedding them into keypad structure?
>>>
>> No particular reason. Will rework it.
>>
> Oops. struct regmap_field is opaque. It seems that the allocation
> is the only way that I could have instance of it.
>

Maybe we can add an API to allocate an array of fields?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

