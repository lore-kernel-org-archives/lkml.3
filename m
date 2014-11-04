Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaKDKs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:48:26 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39056 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbaKDKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:48:22 -0500
Message-ID: <5458AEC5.5020606@st.com>
Date: Tue, 4 Nov 2014 11:47:33 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: <gong.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, <tytso@mit.edu>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel@stlinux.com>, <eric.paire@st.com>
Subject: Re: [PATCH v2] bitops: Fix shift overflow in GENMASK macros
References: <1415095437-28723-1-git-send-email-maxime.coquelin@st.com> <20141104104414.GL3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141104104414.GL3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_05:2014-11-03,2014-11-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/04/2014 11:44 AM, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 11:03:57AM +0100, Maxime COQUELIN wrote:
>
>> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> +#define GENMASK(h, l)     ((~0UL >> (BITS_PER_LONG - (h - l + 1))) << l)
>> +#define GENMASK_ULL(h, l) ((~0ULL >> (BITS_PER_LONG_LONG - (h - l + 1))) << l)
> OK, so you need to keep the (h) and (l) bits, macro arguments should be
> wrapped in seemingly superfluous braces in order to preserve precedence
> on expansion.
You're right, I should have  seen this..
>
> My bad for not explicitly doing that when suggesting the alternative.
Not a problem, v3 is coming.

Maxime
