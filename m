Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaDUHDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 03:03:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23658 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaDUHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 03:03:39 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-01-5354c2c9557f
Message-id: <5354C2CF.5020206@samsung.com>
Date: Mon, 21 Apr 2014 16:03:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: exynos: Use dev_err/info function instead of
 pr_err/info
References: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
 <1397787634-9334-2-git-send-email-cw00.choi@samsung.com>
 <CAKohpo=-Oxu6ZoB4B2H4552meq46iXrVzKbP5ZwnG==sCc2_MA@mail.gmail.com>
In-reply-to: <CAKohpo=-Oxu6ZoB4B2H4552meq46iXrVzKbP5ZwnG==sCc2_MA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkQPfkoZBgg5/bxCyeNv1gt+hdcJXN
	4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZnDl9idXi5J9eRov1M16zWGz86uHA7XHn2h42
	j81L6j22XG1n8ejbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mn9fbmApOsVbMaL/N3sB4hqWL
	kZNDQsBEon3mPShbTOLCvfVsXYxcHEICSxklXjaeYupi5AAr+riHFSI+nVHi4sprUEWvGSX+
	zTjCBtLNK6AlMb/nLROIzSKgKvHq7kZWEJsNKL7/xQ2wGlGBMImV06+wQNQLSvyYDLKZg0ME
	qOblzVSQmcwC/5gl/t/qYAWJCwvESPQf14fYdYxRYsLv7WwgcU6BYIkZu4xAxjALqEtMmreI
	GcKWl9i85i0zSL2EwFt2iQNHehkh7hGQ+Db5EAvEM7ISmw4wQzwsKXFwxQ2WCYxis5BcNAvJ
	2FlIxi5gZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERiZp/89m7CD8d4B60OMyUArJzJL
	iSbnAyM7ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYWw9dXzHTs+Ws1wHblWWd/JERtqtvVPLUeFWxb5LcsqziFqNmX9kFGclpQjserUrpXa9/
	WdCd71bKkY4NLAvf3726JDZrreHnd2UXnIJCLzWpzlF3eSsedOVn789v9vdOHtqxfdus9ec5
	a2eaZa1JlGQ3ObeabfoszZJ/h3aeZ7JWWLJB+dWMNCWW4oxEQy3mouJEAO1x9qHiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd2Th0KCDWbO5bN42vSD3aJ3wVU2
	i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dkceb0JVaLk396GS3Wz3jNYrHxq4cDt8eda3vY
	PDYvqffYcrWdxaNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYwZvy83sZUcIq1Ykb7bfYGxjMsXYwcHBICJhIf97B2MXICmWISF+6tZ+ti5OIQEpjOKHFx
	5TUo5zWjxL8ZR9hAqngFtCTm97xlArFZBFQlXt3dCNbNBhTf/+IGWI2oQJjEyulXWCDqBSV+
	TL4HtkwEqOblzVSQmcwC/5gl/t/qYAWJCwvESPQf14fYdYxRYsLv7WwgcU6BYIkZu4xAxjAL
	qEtMmreIGcKWl9i85i3zBEaBWUg2zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwXH/THoH46oGi0OMAhyMSjy8L/JDgoVYE8uKK3MPMUpwMCuJ8EasBwrxpiRWVqUW5ccX
	leakFh9iTAYGwERmKdHkfGBKyiuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampB
	ahHMFiYOTqkGxvQfkZpXlivHmhaffP63f757xS6Tb48nPu44fMtl+7c7ngaXPhcvKs/6mTnL
	YAnz1p/FT0quqis72iiuM2vSeND0RPf2Ho3L8gcW2jwTez/Ve/er8rafXo/nzrwrn/Oi72x7
	kc9xTtXz0tOeWz6RPH5/VobNUT81va9Zn93qvCw3eqvYLfu7/Z4SS3FGoqEWc1FxIgBEhrN8
	PwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 03:05 PM, Viresh Kumar wrote:
> On 18 April 2014 07:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch uses dev_err/info function to show accurate log message with device name
>> instead of pr_err/info function.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/cpufreq/exynos-cpufreq.c | 21 ++++++++++++---------
>>  drivers/cpufreq/exynos-cpufreq.h |  1 +
>>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> This still looks fine even if we don't take the new driver ?
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for your review.

Best regards,
Chanwoo Choi

