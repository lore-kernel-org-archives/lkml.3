Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaCTKou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:44:50 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:41393 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:44:48 -0400
Message-ID: <532AC6A2.9070307@gmail.com>
Date: Thu, 20 Mar 2014 11:44:50 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>, Tomasz Figa <t.figa@samsung.com>
CC: Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com> <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com> <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com> <532862ED.8040809@samsung.com> <20140319175927.a3feadcacbffe80eca1d3421@samsung.com> <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com> <532988CA.4000008@samsung.com> <20140320190333.9c3555b097e97d593faddbdd@samsung.com>
In-Reply-To: <20140320190333.9c3555b097e97d593faddbdd@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.03.2014 11:03, Cho KyongHo wrote:
> On Wed, 19 Mar 2014 13:08:42 +0100, Tomasz Figa wrote:
>> On 19.03.2014 10:01, Sachin Kamat wrote:
>>> On 19 March 2014 14:29, Cho KyongHo <pullip.cho@samsung.com> wrote:
>>>> On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
>>>>> On 18.03.2014 12:09, Cho KyongHo wrote:
>>>>>> On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
>>>>>>> Hi KyongHo,
>>>>>>>
>>>>>>> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
>>>>>>>> This patch uses managed device helper functions in the probe().
>>>>>>>>
>>>>>>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>>>>>>>> ---
>>>>>>> [snip]
>>>>>>>
>>>>>>>> +       data->clk = devm_clk_get(dev, "sysmmu");
>>>>>>>> +       if (IS_ERR(data->clk)) {
>>>>>>>> +               dev_info(dev, "No gate clock found!\n");
>>>>>>>> +               data->clk = NULL;
>>>>>>>> +       }
>>>>>>>
>>>>>>> Why aren't you returning from here upon error?
>>>>>>
>>>>>> It is for the case of a System MMU which does not need clock gating.
>>>>>>
>>>>>
>>>>> Are there really such cases?
>>>>>
>>>>
>>>> Yes.
>>>> Especially in the case of initial stage of new SoC development.
>>>>
>>>> I have experianced some software workaround for H/W restriction
>>>> needs prevention of clock gating for some devices.
>>>
>>> So aren't these basically some exceptions/hacks rather than the usual way
>>> of functioning of the device?
>>>
>>
>> This actually raises a good question, whether we really need to support
>> such early development SoC versions in mainline.
>>
>> Another thing is that if you need to assure that a clock is ungated, you
>> must acquire it and prepare_enable explicitly, so I don't think this
>> kind of handling is correct.
>>
> On early development step of a new SoC, clock related stuffs and
> some device drivers like display controller are usually developed in parallel.
>
> In that case, -ENOENT from clk_get() must not treated as an error.
> "[PATCH v11 20/17] iommu/exynos: allow having multiple System MMUs for a master H/W"
> patch distinguishes -ENOENT from other error values returned by devm_clk_get().

I still don't think upstream is right place for such development hacks 
and such assumption will mask potential errors caused by clocks 
unspecified in DT.

If such thing is needed for development, an extra patch might be kept in 
development tree, until clock driver is implemented or a dummy 
fixed-rate clock might be specified in DT.

Best regards,
Tomasz
