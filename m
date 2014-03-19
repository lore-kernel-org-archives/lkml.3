Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbaCSMIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:08:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20160 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbaCSMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:08:50 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-af-532988cf6aa6
Message-id: <532988CA.4000008@samsung.com>
Date: Wed, 19 Mar 2014 13:08:42 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>,
        Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
 <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
 <532862ED.8040809@samsung.com>
 <20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
 <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com>
In-reply-to: <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4Nd3zHZrBBs8uClvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpYs6qDseAqT8XBla9YGxi/c3YxcnJICJhI9K89xgZh
	i0lcuLceyObiEBJYyijxcvFyFgjnM6PEvMU9zCBVvAJaEp9vPmYCsVkEVCXen7sJ1s0moCbx
	ueERmM0PVLOm6ToLiC0qECExd+JmNoheQYkfk++BxUUEAiRO/F7CDLKAWeA6i8Sz47vYQRLC
	QIkXJxugNj9gklg74yTQNg4OToFgiZVPLEBqmAWsJVZO2sYIYctLbF7zlnkCo+AsJDtmISmb
	haRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQqPuyg3HxMatDjAIcjEo8vJKxGsFC
	rIllxZW5hxglOJiVRHgP1WsGC/GmJFZWpRblxxeV5qQWH2Jk4uCUamA0fJXot6TDzjdAwb7h
	//EnT1cLX5vy2GPjccWiqOkz4s+pdK9dnxEe3C20b9bPOcL6f/59tWfvm7/29Z5cnwenp2Rw
	L5+0P9XRIe6RqOrySXwnC+ynvJdtVpt/TazG84gsT5uCWLhgfKaTw3/ZfeV+0mHX+hdd7/qt
	fUBd49cOb+WQuunphdJKLMUZiYZazEXFiQCp2FmAmAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2014 10:01, Sachin Kamat wrote:
> On 19 March 2014 14:29, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
>>> On 18.03.2014 12:09, Cho KyongHo wrote:
>>>> On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
>>>>> Hi KyongHo,
>>>>>
>>>>> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
>>>>>> This patch uses managed device helper functions in the probe().
>>>>>>
>>>>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>>>>>> ---
>>>>> [snip]
>>>>>
>>>>>> +       data->clk = devm_clk_get(dev, "sysmmu");
>>>>>> +       if (IS_ERR(data->clk)) {
>>>>>> +               dev_info(dev, "No gate clock found!\n");
>>>>>> +               data->clk = NULL;
>>>>>> +       }
>>>>>
>>>>> Why aren't you returning from here upon error?
>>>>
>>>> It is for the case of a System MMU which does not need clock gating.
>>>>
>>>
>>> Are there really such cases?
>>>
>>
>> Yes.
>> Especially in the case of initial stage of new SoC development.
>>
>> I have experianced some software workaround for H/W restriction
>> needs prevention of clock gating for some devices.
>
> So aren't these basically some exceptions/hacks rather than the usual way
> of functioning of the device?
>

This actually raises a good question, whether we really need to support 
such early development SoC versions in mainline.

Another thing is that if you need to assure that a clock is ungated, you 
must acquire it and prepare_enable explicitly, so I don't think this 
kind of handling is correct.

Best regards,
Tomasz
