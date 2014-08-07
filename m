Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaHGL62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:58:28 -0400
Received: from ozlabs.org ([103.22.144.67]:47190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377AbaHGL61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:58:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [microcode/load_module] WARNING: CPU: 0 PID: 1444 at kernel/sched/core.c:7094 __might_sleep+0x51/0x16f()
In-Reply-To: <20140807104140.GN19379@twins.programming.kicks-ass.net>
References: <20140805211224.GA13480@localhost> <20140807104140.GN19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 07 Aug 2014 21:26:15 +0930
Message-ID: <87r40scy3k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
> On Wed, Aug 06, 2014 at 05:12:24AM +0800, Fengguang Wu wrote:
>> Greetings,
>> 
>> Here is a microcode/load_module error triggered by debug check commit
>> 64c2181bc433b17f04da8fe8592aa83cceac9606 ("sched: Debug nested
>> sleeps"):

Hmm, google lead me to that.  Yuck, that's subtle.

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-xtd4qlahotb7ar4bmo9lapz8@git.kernel.org
> ---
>  kernel/module.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3094,6 +3094,28 @@ static int may_init_module(void)
>  	return 0;
>  }
>  
> +int wait_finished_loading(struct module *mod)
> +{

Is this something we can generalize?  At least needs a comment on
why we don't just use the normal wait_event_interruptible...

Cheers,
Rusty.
