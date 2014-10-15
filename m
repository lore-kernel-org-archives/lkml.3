Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaJOFYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:24:50 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51701 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaJOFYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:24:48 -0400
Message-ID: <543E0511.3050505@st.com>
Date: Wed, 15 Oct 2014 07:24:33 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <sfr@canb.auug.org.au>
Cc: <netdev@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net tree
References: <20141015104411.306b138e@canb.auug.org.au> <20141014.220254.144210672646232483.davem@davemloft.net>
In-Reply-To: <20141014.220254.144210672646232483.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.72]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-15_02:2014-10-14,2014-10-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 4:02 AM, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 15 Oct 2014 10:44:11 +1100
>
>> Hi all,
>>
>> After merging the net tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>> drivers/built-in.o: In function `.LANCHOR0':
>> :(.rodata+0x6b764): undefined reference to `sti_gmac_data'
>> :(.rodata+0x6b828): undefined reference to `sti_gmac_data'
>> :(.rodata+0x6b8ec): undefined reference to `sti_gmac_data'
>> :(.rodata+0x6b9b0): undefined reference to `sti_gmac_data'
>>
>> Caused by commit 53b26b9bc9a5 ("stmmac: dwmac-sti: review the
>> glue-logic for STi4xx and STiD127 SoCs") which renamed sti_gmac_data to
>> stih4xx_dwmac_data (or something) without updating all the references
>> to it (including the one added in the previous commit ...).
>>
>> I reverted that commit for today.
>
> Sigh, Giuseppe if I don't see a proper fix by tomorrow I'm
> reverting all of the stmmac changes I applied today.

I am looking at this now and let you know soon

peppe
