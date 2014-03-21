Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbaCULW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:22:28 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52757 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760658AbaCULW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:22:27 -0400
Message-ID: <532C206E.1020907@st.com>
Date: Fri, 21 Mar 2014 12:20:14 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Cc: <mark.rutland@arm.com>, <mturquette@linaro.org>,
        <gregkh@linuxfoundation.org>, <t.figa@samsung.com>,
        <sw0312.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <robh+dt@kernel.org>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <m.szyprowski@samsung.com>,
        <t-kristo@ti.com>
Subject: Re: [RFC PATCH v2 0/2] clk: Support for DT assigned clock parents
 and rates
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com> <53187C13.3040202@st.com> <532AE239.9000800@samsung.com>
In-Reply-To: <532AE239.9000800@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.129.4.202]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-21_03:2014-03-21,2014-03-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/20/2014 01:42 PM, Sylwester Nawrocki wrote:
> Hi Maxime,
>
> On 06/03/14 14:45, Maxime Coquelin wrote:
>> Hi Sylwester,
>>
>> 	I like the principle of your implementation, but I have two questions:
>> 	1 - How can we manage PM with this solution, as the parent/rate will be
>> set only once at probe time?
>> 	2 - How to set the parent of a parent clock (which can be shared with
>> other devices)? Same question about the parent rates.
>
> Thanks for your feedback and apologies for late reply.
No problem! Apologies accepted ;)

>
> IIUC your first concern is about a situation when clocks need to be
> reconfigured upon each resume from system sleep or runtime PM resume ?

Yes. This is the case of the STi SoCs.
When resuming from system sleep, the clocks-related registers are 
restored at their boot state.

> As I mentioned in v1 of the RFC I was considering having individual
> drivers calling explicitly the clocks set up routine. Presumably this
> would allow to resolve the power management related issue.
 From a functional point of view, that would indeed resolve the PM 
related issue.
But I'm not sure that on a performance point of view, parsing the DT at 
each driver's resume call is an efficient way.

> One example I'm aware the approach as in this RFC wouldn't work is
> when a device in a SoC belongs to a power domain, which needs to be
> first switched on before we can start setting up and the clocks'
> configuration get lost after the power domain switch off.
Yes, that's another case to handle.
I don't know which platforms are in that case, but not STi SoCs for your 
information.

>
> OTOH I suspect devices for which one-time clocks setup is sufficient
> will be quite common. And for these there would need to be a single
> call to the setup routine in probe() I guess, since it wouldn't be
> possible to figure out just from the DT data when the actual call
> should be made.
>
> For a global clocks configuration, I thought about specifying that
> in the clocks controller node, and then to have the setup routine
> called e.g. from of_clk_init(). I think that could work well enough,
> together with the patch [1], adding clock dependencies handling.
> But then the clock frequency set up function would need to be
> modified to respect the clock parent relationships, similarly as
> in patch series [2]. A just noticed [2] recently, after posting
> this RFC (adding Tero at Cc).
OK, I agree with the approach.
There is still the PM issue remaining with these clocks, but I think 
that is not related to your series as we already have the issue currently.

Thanks,
Maxime

>
> --
> Regards,
> Sylwester
>
> [1] http://www.spinics.net/lists/arm-kernel/msg310507.html
> [2] http://www.spinics.net/lists/linux-omap/msg103069.html
>
