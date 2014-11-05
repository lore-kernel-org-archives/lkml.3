Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaKEPsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:48:11 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:53720 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771AbaKEPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:48:08 -0500
Message-ID: <545A4682.2080302@st.com>
Date: Wed, 5 Nov 2014 16:47:14 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: <gong.chen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, <tytso@mit.edu>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel@stlinux.com>, <eric.paire@st.com>
Subject: Re: [PATCH v3] bitops: Fix shift overflow in GENMASK macros
References: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com> <87vbmt52dm.fsf@rasmusvillemoes.dk>
In-Reply-To: <87vbmt52dm.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-05_06:2014-11-05,2014-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/05/2014 12:10 PM, Rasmus Villemoes wrote:
> On Tue, Nov 04 2014, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
>
>> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> +#define GENMASK(h, l) \
>> +	((~0UL >> (BITS_PER_LONG - ((h) - (l) + 1))) << (l))
>> +
>> +#define GENMASK_ULL(h, l) \
>> +	((~0ULL >> (BITS_PER_LONG_LONG - ((h) - (l) + 1))) << (l))
> Slightly bikeshedding here, but may I suggest spelling it
>
>    (((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
>
> ? This will ensure the arguments are expanded once each, and will, IMHO,
> DTRT if/when l > h (namely, yield 0).
That's a good point.

Peter, what is your view?

Kind regards,
Maxime
>
> Rasmus

