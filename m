Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaGKJoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:44:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31989 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGKJn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:43:59 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-61-53bfb1dc64af
Message-id: <53BFB1BA.6030108@samsung.com>
Date: Fri, 11 Jul 2014 11:43:22 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        amit daniel kachhap <amit.daniel@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Tushar Behera <trblinux@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Andreas Farber <afaerber@suse.de>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 08/24] mfd: max77686: Add Dynamic Voltage Scaling (DVS)
 support
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk>
 <CADGdYn6tyTBZOjZH8JBUVMJ1kh-tht=tkU4tA+oM=PbfTYkqGw@mail.gmail.com>
 <53BF41C8.4080304@collabora.co.uk>
In-reply-to: <53BF41C8.4080304@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xK7p3Nu4PNliyXMNiycWr7BbNm4ot
	Gq6GWEx9+ITNYv6Rc6wWZ5cdZLM4+rvA4vULQ4veBVfZLO5/Pcpo8e1KB5PFpsfXWC0u75rD
	ZjHj/D4mi6cTLrJZnLr+mc2ib+0lNosNk3ezW8z93cjqIOwxu+Eii8ff59dZPHbcXcLosXPW
	XXaPTas62TzuXNvD5rF5Sb3HlRNNrB59W1Yxemw+Xe0xfd5PJo/Pm+QCeKK4bFJSczLLUov0
	7RK4MrY87GQt6Oav2H17FmMD42PuLkZODgkBE4mTN08xQdhiEhfurWfrYuTiEBJYyijx5sYP
	dgjnM6PEnuNnGEGqeAW0JJ7N2s4KYrMIqEr8fjQLrJtNQE3ic8MjNhCbH6hmTdN1li5GDg5R
	gQiJxxeEIFoFJX5MvscCYosI5Etc/fEebBmzwC1WiYV/H4AlhEHqV82EWtzIJDFl/3VmkASn
	gL7EwjlPwBYwC6hLTJq3iBnClpfYvOYt8wRGwVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGCEx+2UH4+JjVocYBTgYlXh4NWp3BwuxJpYVV+YeYpTgYFYS4X1Svz9Y
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA+OyxavPvFnbNKf4gNmreOMzLFP4WXe9KVO/F8i2mn3J
	7Tir7zIdElFnzh5Mv65qf2dbgIqr6+H8Kcc0xN+cfl7weo+YX+RnS7tV72VcllhwnYmJctP/
	H+ZQuuVAzN6s5wHXDjNNVHj6i8m47/aR2Ufrxcxcd9sJM318vP3yfP/WvGqjCb66YX+UWIoz
	Eg21mIuKEwHgFTBFtwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 11.07.2014 03:45, Javier Martinez Canillas wrote:
> On 07/10/2014 11:59 AM, amit daniel kachhap wrote:
>> On Sat, Jul 5, 2014 at 1:54 AM, Javier Martinez Canillas
>> <javier.martinez@collabora.co.uk> wrote:

[snip]

>>> @@ -111,6 +223,13 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
>>>                 return NULL;
>>>
>>>         dev->platform_data = pd;
>>> +
>>> +       /* Read default index and ignore errors, since default is 0 */
>>> +       of_property_read_u32(np, "max77686,pmic-buck-default-dvs-idx",
>>> +                            &pd->buck_default_idx);
>> Any error checking code here. Say if pmic-buck-default-dvs-idx exceed 8?
> 
> I'm not a DT expert but AFAIK the kernel should expect the data in a FDT to be
> correct and should not validate it on runtime. There is work-in-progress to add
> a proper schema checking for DTS to the dtc so on build time it can be validated
> that a DTS is valid.
> 
> AFAIU the only thing that the kernel should check is if a required property does
> not exist.

I'd disagree on this.

IMHO schema (if it progresses further, as unfortunately I can't find
time to dedicate to it and looks like it's similar for other people that
used to be involved) should be focused on structural checks, i.e. proper
layout of nodes and properties, basic data types and so, to figure out
common errors earlier than at boot-up time.

On kernel side this should be treated in the same way as platform data.
I agree that some existing drivers do little to validate incoming data,
but I believe it is a good practice to validate things that the driver
has no control over, especially when it's about a PMIC, when invalid
data can have quite serious effects and detecting even some of them
(e.g. value to big, which would overflow in target bit field) might
prevent a failure.

Best regards,
Tomasz
