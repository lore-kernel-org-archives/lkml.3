Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KLCgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:36:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51915 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KLCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:35:57 -0500
Message-ID: <5281940C.3040705@codeaurora.org>
Date: Mon, 11 Nov 2013 18:35:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5?= =?ISO-8859-1?Q?rd?= 
	<mans@mansr.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <20131111074633.GG14892@pengutronix.de>
In-Reply-To: <20131111074633.GG14892@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 23:46, Uwe Kleine-König wrote:
> Hello,
>
> On Fri, Nov 08, 2013 at 03:00:32PM -0800, Stephen Boyd wrote:
>> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
>> index bd454b0..38621729 100644
>> --- a/arch/arm/lib/Makefile
>> +++ b/arch/arm/lib/Makefile
>> @@ -15,6 +15,12 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
>>  		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
>>  		   call_with_stack.o
>>  
>> +lib-$(CONFIG_CPU_V7) += div-v7.o
> CPU_V7M could make use of that, too.
> (If you follow Nico's advice to use runtime patching I cannot test it
> for you on v7-M though as my machine has to use an XIP kernel.)
>

It already is runtime patching so I suspect you won't be able to test it
anyway. I suppose we need another config like MIGHT_HAVE_IDIV or
something that both v7 and v7M select?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

