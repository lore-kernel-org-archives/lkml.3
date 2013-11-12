Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3KLBXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:23:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47344 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3KLBXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:23:13 -0500
Message-ID: <52818300.70003@codeaurora.org>
Date: Mon, 11 Nov 2013 17:23:12 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matt Sealey <neko@bakuhatsu.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <CAHCPf3tCTUEX6oDLUndZwt=Hk+YxsKjPO96N=Zhx82+_LM66sQ@mail.gmail.com>
In-Reply-To: <CAHCPf3tCTUEX6oDLUndZwt=Hk+YxsKjPO96N=Zhx82+_LM66sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 22:46, Matt Sealey wrote:
> On Fri, Nov 8, 2013 at 5:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> If we're running on a v7 ARM CPU, detect if the CPU supports the
>> sdiv/udiv instructions and replace the signed and unsigned
>> division library functions with an sdiv/udiv instruction.
>>
>> Running the perf messaging benchmark in pipe mode
>>
>>  $ perf bench sched messaging -p
>>
>> shows a modest improvement on my v7 CPU.
>>
>> before:
>> (5.060 + 5.960 + 5.971 + 5.643 + 6.029 + 5.665 + 6.050 + 5.870 + 6.117 + 5.683) / 10 = 5.805
>>
>> after:
>> (4.884 + 5.549 + 5.749 + 6.001 + 5.460 + 5.103 + 5.956 + 6.112 + 5.468 + 5.093) / 10 = 5.538
>>
>> (5.805 - 5.538) / 5.805 = 4.6%
> Even with the change to the output constraint suggested by Mans, you
> get absolutely identical benchmark results? There's a lot of variance
> in any case..

Yeah sorry I didn't run the testcase again to see if numbers changed
because I assumed one less instruction would be in the noise. I agree
there is a lot of variance so if you have any better
benchmarks/testcases please let me know.

>
> BTW has there been any evaluation of the penalty for the extra
> branching, or the performance hit for the ARMv7-without-division
> cases?

I haven't done any. I'll factor that in for the next round.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

