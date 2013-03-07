Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab3CGXlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:41:08 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:60008 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3CGXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130220163258.GB16780@pd.tnic>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	<1357610913-1080-8-git-send-email-fweisbec@gmail.com>
	<20130211143529.GB2749@pd.tnic>
	<20130220163258.GB16780@pd.tnic>
Date: Fri, 8 Mar 2013 00:41:03 +0100
Message-ID: <CAFTL4hzY0rNjgu9Uqk+YHBL27ik+ycxPxSU83MHV6MG8qg1ZkA@mail.gmail.com>
Subject: Re: [PATCH 07/33] nohz: Basic full dynticks interface
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Borislav Petkov <bp@alien8.de>:
> On Mon, Feb 11, 2013 at 03:35:29PM +0100, Borislav Petkov wrote:
>> > +/* Parse the boot-time nohz CPU list from the kernel parameters. */
>> > +static int __init tick_nohz_full_setup(char *str)
>> > +{
>> > +   alloc_bootmem_cpumask_var(&full_nohz_mask);
>> > +   have_full_nohz_mask = true;
>> > +   cpulist_parse(str, full_nohz_mask);
>>
>> Don't you want to check retval of cpulist_parse first here before
>> assigning have_full_nohz_mask and allocating cpumask var?
>>
>> We don't trust userspace, you know.
>>
>> > +   return 1;
>> > +}
>> > +__setup("full_nohz=", tick_nohz_full_setup);
>
> One more thing. AFAICT, full_nohz requires rcu_nocbs to pass in the same
> mask, right?

Right!

> Maybe tick_nohz_full_setup() could be made to call rcu_nocb_setup()
> without the need to pass "rcu_nocbs=" option on the cmd line; in the
> sense that if user supplies a full_nohz mask, she wants the same mask
> for rcu_nocbs...

Yeah that's probably something we want. (added to the TODO list)

Thanks.
