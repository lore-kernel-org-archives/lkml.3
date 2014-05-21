Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaEUMwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:52:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36582 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaEUMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:52:53 -0400
Message-ID: <537CA180.4050907@st.com>
Date: Wed, 21 May 2014 14:52:16 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: divider: Fix table round up function
References: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com> <CAOMZO5C9iqLj34mJdztqZsyLNR6oHztyN2GxDY0ORp+0xU1+LA@mail.gmail.com>
In-Reply-To: <CAOMZO5C9iqLj34mJdztqZsyLNR6oHztyN2GxDY0ORp+0xU1+LA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-21_05:2014-05-21,2014-05-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/15/2014 03:28 PM, Fabio Estevam wrote:
> Hi Mike,
>
> On Wed, May 7, 2014 at 1:48 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
>> Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
>> table dividers") introduces a regression in its _table_round_up function.
>>
>> When the divider passed to this function is greater than the max divider
>> available in the table, this function returns table's max divider.
>> Problem is that it causes an infinite loop in clk_divider_bestdiv() because
>> _next_div() will never return a value greater than maxdiv.
>>
>> Instead of returning table's max divider, this patch returns INT_MAX.
>>
>> Reported-by: Fabio Estevam <festevam@gmail.com>
>> Reported-by: Shawn Guo <shawn.guo@freescale.com>
>> Tested-by: Fabio Estevam <festevam@gmail.com>
>> Cc: Mike Turquette <mike.turquette@linaro.org>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>
> Any comments on this one? It does fix a regression.
>

This patch is important as it fixes a regression, could you review it 
please?

Thanks,
Maxime
