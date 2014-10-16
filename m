Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaJPI6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:58:43 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48136 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbaJPI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:58:41 -0400
Message-ID: <543F88AE.2020702@st.com>
Date: Thu, 16 Oct 2014 10:58:22 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <hliang1025@gmail.com>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <adi-linux-docs@lists.sourceforge.net>
Subject: Re: [PATCH] net: ethernet : stmicro: fixed power suspend and resume
 failure in stmmac driver
References: <1412056534-7995-1-git-send-email-hliang1025@gmail.com>	<20140930.151056.950254777090461575.davem@davemloft.net>	<CAPig_t=oA6BuAt77DDsLqrtRBDbV_vsoAxM31XxLjkAFpYG1-Q@mail.gmail.com> <20141001.134508.1301867654128829684.davem@davemloft.net>
In-Reply-To: <20141001.134508.1301867654128829684.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.72]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-16_04:2014-10-15,2014-10-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hao Liang

On 10/1/2014 7:45 PM, David Miller wrote:
> From: Hao Liang <hliang1025@gmail.com>
> Date: Wed, 1 Oct 2014 14:08:28 +0800
>
>> I double-check my patch and the ->mac->xxx calls are still under the lock.
>> I think that lock is trying to protect priv struct and related data, so i
>> just remove some functions have no bearing on priv struct.
>
> It's preventing parallel invocations of the ->mac->xxx calls.
>
> The other instances are in device open/close, where RTNL semaphore is
> held, and no other code paths in the driver can be active.
>
> You need the lock.

Do you have a new patch for this problem after David's advice?

I am reviewing the patches sent some weeks ago for driver looking
and I can also try to fix this in case of you have no news.

Let me know,

Regards,
peppe

