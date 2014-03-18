Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaCRPPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:15:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35347 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbaCRPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:14:59 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-99-532862f1d265
Message-id: <532862ED.8040809@samsung.com>
Date: Tue, 18 Mar 2014 16:14:53 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
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
In-reply-to: <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Vd2PSRrBBs8XaFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mo4uuI6S8FL1opV30+xNjCuYeli5OSQEDCRuLFhFROE
	LSZx4d56ti5GLg4hgaWMEn/vPGMESQgJfGaUuHBWCcTmFdCS2Lh8LSuIzSKgKnHmSzcbiM0m
	oCbxueERmM0PVLOm6TrYAlGBCIm5EzezQfQKSvyYfA8sLiIQIPFm4UJmkGXMAtdZJJ4d38UO
	khAGSrw42cACsfgAo8TCicEgNqeAk8TDZRvBBjELWEusnLSNEcKWl9i85i3zBEbBWUh2zEJS
	NgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYITH3ZQfj4mNWhxgFOBiVeHglYzWC
	hVgTy4orcw8xSnAwK4nwrnYHCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBMy5ngJ9lU23/y4o7H
	RQX9Wu1KIsVxPwxsvm+dOL/FJMjp6gVXhmZXxRUfVcXZjFv3f0o9e++4y8G9ZdGnJdIv/LU7
	Xhq2Vzn4xBk+MYG6L/l9ojOWn7t5z0aepdVM09L8/QefR+cV3G77VrCVn9icqluTuTky/O2+
	g1KnGt85lTfNerEwulWJpTgj0VCLuag4EQBsJItzlwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 12:09, Cho KyongHo wrote:
> On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
>> Hi KyongHo,
>>
>> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
>>> This patch uses managed device helper functions in the probe().
>>>
>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>>> ---
>> [snip]
>>
>>> +       data->clk = devm_clk_get(dev, "sysmmu");
>>> +       if (IS_ERR(data->clk)) {
>>> +               dev_info(dev, "No gate clock found!\n");
>>> +               data->clk = NULL;
>>> +       }
>>
>> Why aren't you returning from here upon error?
>
> It is for the case of a System MMU which does not need clock gating.
>

Are there really such cases?

Best regards,
Tomasz
