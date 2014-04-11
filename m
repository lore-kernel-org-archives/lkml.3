Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827AbaDKOib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:38:31 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60286 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529AbaDKOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:38:21 -0400
Message-ID: <5347FE56.5000206@twiddle.net>
Date: Fri, 11 Apr 2014 07:38:14 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de, luto@amacapital.net, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, umgwanakikbuti@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/8] sched,idle,alpha: Switch from TS_POLLING to
 TIF_POLLING_NRFLAG
References: <20140411134243.160989490@infradead.org> <20140411135218.181563050@infradead.org>
In-Reply-To: <20140411135218.181563050@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 06:42 AM, Peter Zijlstra wrote:
> Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
> both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
> This will allow us, using fetch_or(), to both set NEED_RESCHED and
> check for POLLING_NRFLAG in a single operation and avoid pointless
> wakeups.
> 
> Changing from the non-atomic thread_info::status flags to the atomic
> thread_info::flags shouldn't be a big issue since most polling state
> changes were followed/preceded by a full memory barrier anyway.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Richard Henderson <rth@twiddle.net>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/alpha/include/asm/thread_info.h |    4 ++--
>  1 file changed, 2 inser

Acked-by: Richard Henderson <rth@twiddle.net>


r~
