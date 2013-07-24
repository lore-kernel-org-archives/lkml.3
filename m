Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3GXXuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:50:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52343 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3GXXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:50:18 -0400
X-AuditID: cbfee68e-b7f276d000002279-ea-51f06836793a
Message-id: <51F06836.2010501@samsung.com>
Date: Thu, 25 Jul 2013 08:50:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/2] extcon: gpio: Use power efficient workqueue for
 debounce
References: <1374256055-26894-1-git-send-email-broonie@kernel.org>
 <CAKohpo=4NFNB6XVqjiqw2vMAWgiOLZv=OWKYtcC7JBw1eNX6Sg@mail.gmail.com>
In-reply-to: <CAKohpo=4NFNB6XVqjiqw2vMAWgiOLZv=OWKYtcC7JBw1eNX6Sg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkWNcs40OgQed9PoupD5+wWWy6fp3V
	4v2hZ8wWl3fNYbO43biCzWLjVw8HNo9NqzrZPO5c28PmcfvfY2aPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgyth7bjdjwUeWiu/r1jA1MP5g7mLk5JAQMJHYceMWG4QtJnHh3nogm4tDSGAp
	o8S3OztYYIoWdB+CSkxnlNjeeQysW0jgFaNEzxIzEJtXQEuia0MXWJxFQFXi88z5rCA2G1B8
	/4sbYBtEBcIkVk6/wgJRLyjxY/I9IJuDQwSo5uXNVJD5zALrGSUOX18LViMsECyx7ukdRojF
	nYwS7bcngA3lBErMfdrNCGIzC+hI7G+dxgZhy0tsXvOWGaRBQuAQu8S8RV8YIS4SkPg2+RDY
	NgkBWYlNB6Del5Q4uOIGywRGsVlIbpqFZOwsJGMXMDKvYhRNLUguKE5KLzLSK07MLS7NS9dL
	zs/dxAiMttP/nvXtYLx5wPoQYzLQyonMUqLJ+cBozSuJNzQ2M7IwNTE1NjK3NCNNWEmcV63F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo8jNw7sYQ72L851nuj1nfRXxdO6F00InmJ4e
	uxymEVLPpPB06qqvR7KaPk35tmp2Duv0B3+ndNz8e4yD/xnrjnvS31+zvfaI+jahNO3blgUz
	GEucLlQGLNU+f7TGItK+rOhrofG1X9cN5uX27FrZsZZ3SkDJct5tfAo8l9jX7D/7ruit4FaX
	S/+UWIozEg21mIuKEwGefUnBzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV2zjA+BBlPfs1tMffiEzWLT9eus
	Fu8PPWO2uLxrDpvF7cYVbBYbv3o4sHlsWtXJ5nHn2h42j9v/HjN79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMved2MxZ8ZKn4vm4NUwPjD+YuRk4O
	CQETiQXdh9ggbDGJC/fWA9lcHEIC0xkltnceAysSEnjFKNGzxAzE5hXQkuja0AUWZxFQlfg8
	cz4riM0GFN//4gbYIFGBMImV06+wQNQLSvyYfA/I5uAQAap5eTMVZD6zwHpGicPX14LVCAsE
	S6x7eocRYnEno0T77QlgQzmBEnOfdjOC2MwCOhL7W6exQdjyEpvXvGWewCgwC8mOWUjKZiEp
	W8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJafSe1gXNlgcYhRgINRiYd3xff3gUKs
	iWXFlbmHGCU4mJVEeN8+AArxpiRWVqUW5ccXleakFh9iTAYGwURmKdHkfGCaySuJNzQ2MTOy
	NDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRsnEp9xyEecjWFbahKTznzg8
	9eCFVenH/Pwylk9g7ZMVy7swndW67MDKW1M0wxMiuhJntv2UKD1gqyJgU7n8/NeqjwsYloV7
	mZ94vM3j+I0exZtHvaq/3Aia2dYq5jVLJOwre9y/p3l8zxtkZZZLqPE/W9OVUVl2YZHR7MWq
	YaFh2yYY2M+0V2Ipzkg01GIuKk4EACDzzbYpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 07/22/2013 01:27 PM, Viresh Kumar wrote:
> On 19 July 2013 23:17, Mark Brown <broonie@kernel.org> wrote:
>> From: Mark Brown <broonie@linaro.org>
>>
>> The debounce timeout is generally quite long and the work not performance
>> critical so allow the scheduler to run the work anywhere rather than in
>> the normal per-CPU workqueue.
>>
>> Signed-off-by: Mark Brown <broonie@linaro.org>
>> ---
>>  drivers/extcon/extcon-gpio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

This patchset is applied.

Thanks,
Chanwoo Choi
