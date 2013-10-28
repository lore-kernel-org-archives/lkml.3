Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3J1JSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:18:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35823 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3J1JSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:18:15 -0400
Message-ID: <526E2BD0.3080807@hitachi.com>
Date: Mon, 28 Oct 2013 18:18:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz> <52629F08.2010609@hitachi.com> <20131019151658.583ac18e@gandalf.local.home> <20131019151919.2d4778d2@gandalf.local.home> <20131019213350.GH4118@linux.vnet.ibm.com> <20131019180239.1e318628@gandalf.local.home> <20131020154203.GN4118@linux.vnet.ibm.com>
In-Reply-To: <20131020154203.GN4118@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/21 0:42), Paul E. McKenney wrote:
> On Sat, Oct 19, 2013 at 06:02:39PM -0400, Steven Rostedt wrote:
>> On Sat, 19 Oct 2013 14:33:50 -0700
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>
>>
>>>>> It's used to convert the calls to mcount to nops. But maybe a better
>>>>> thing to do is to check if we only have a single CPU:
>>>>>
>>>>> static void run_sync(void)
>>>>> {
>>>>> 	if (num_online_cpus() != 1)
>>>>
>>>> Hmm, to be more robust to handle our future "ideal" machines, perhaps
>>>> this should be:
>>>>
>>>> 	/* Ideally we would like to run on zero CPUS! */
>>>> 	if (num_online_cpus() < 2)
>>>
>>
>> Bah! And for such a simple computation, I got it wrong.
>>
>>
>> 	/* Ideally we would like to run on zero CPUS! */
>> 	if (num_online_cpus > 1)
>>
>> But I guess the question comes. If we are running on zero CPUS, should
>> we perform the "on_each_cpu(do_sync_core, NULL, 1);" or not? Same goes
>> with 5i-3 CPUS, or negative number CPUs. If we need to do on_each_cpu(),
>> then I guess the != 1 will suffice.
> 
> Makes sense to me!  Whoever adds the ability to run on zero, negative,
> or complex numbers of CPUs can adjust on_each_cpu() accordingly.

Thanks for making it clear!

Petr, could you update your patch according to this discussion?
I think temporally enabling irq is not a good idea.

BTW, adding an assertion(BUG_ON(irq_disabled()) at the top of text_poke_bp)
will be good for debugging.

Thanks again!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


