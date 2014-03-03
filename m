Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaCCJEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:04:45 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754036AbaCCJEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:04:41 -0500
Message-ID: <531445A7.1090001@nod.at>
Date: Mon, 03 Mar 2014 10:04:39 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/44] arc: Use get_signal() signal_setup_done()
References: <1393804559-7701-1-git-send-email-richard@nod.at> <1393804559-7701-2-git-send-email-richard@nod.at> <C2D7FE5348E1B147BCA15975FBA2307517FC80@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307517FC80@IN01WEMBXA.internal.synopsys.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.03.2014 09:44, schrieb Vineet Gupta:
> On Monday 03 March 2014 05:26 AM, Richard Weinberger wrote:
>> Use the more generic functions get_signal() signal_setup_done()
>> for signal delivery.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> I gave the git branch some light testing and it works well.

Thx!

> Minor comment below, otherwise 
> 
> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> 
> P.S. Since this depends on translate_sig change, I can't possibly take it via ARC
> tree.

I hope we can merge this via Al's signal.git tree.

> Thx,
> -Vineet
> 
>> ---
>>  arch/arc/kernel/signal.c | 39 +++++++++++++++------------------------
>>  1 file changed, 15 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
>> index 7e95e1a..c2031e2 100644
>> --- a/arch/arc/kernel/signal.c
>> +++ b/arch/arc/kernel/signal.c
>> @@ -179,14 +179,13 @@ static inline int map_sig(int sig)
>>  }
>>  
>>  static int
>> -setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
>> -	       sigset_t *set, struct pt_regs *regs)
>> +setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
>>  {
>>  	struct rt_sigframe __user *sf;
>>  	unsigned int magic = 0;
>>  	int err = 0;
>>  
>> -	sf = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
>> +	sf = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
> 
> Can we pass ksig pointer kere (and a pairing change to get_sigframe). This will
> reduce the code churn when we do the sigsp() change in there.

Will do!

Thanks,
//richard
