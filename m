Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3C2AjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 20:39:09 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50875 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3C2AjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 20:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130329002555.GA3444@windriver.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
	<1364398359-21990-3-git-send-email-fweisbec@gmail.com>
	<20130328074045.GB24433@gmail.com>
	<20130329002555.GA3444@windriver.com>
Date: Fri, 29 Mar 2013 01:39:04 +0100
Message-ID: <CAFTL4hzz1jKu0tZn=-d0_csvYM_m9L+eRpw1qmmn30iC7cU=BQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/29 Paul Gortmaker <paul.gortmaker@windriver.com>:
> [Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot] On 28/03/2013 (Thu 08:40) Ingo Molnar wrote:
>
>>
>> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> > +   cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
>> > +   pr_info("NO_HZ: Experimental full dynticks CPUs: %s.\n", nohz_ext_buf);
>>
>> I'd suggest removing the 'experimental' word. We are not sending anything
>> experimental to Linus: we'll send something that is tested and that we
>> expect to not break anything. (and which we'll fix if it does)
>
> In that case, should we vector a patch through PaulM to clobber these too?
>
> $ git grep xperiment |grep rcu
> kernel/rcutree_plugin.h: printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
> kernel/rcutree_plugin.h: pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
> kernel/rcutree_plugin.h: pr_info("\tExperimental polled no-CBs CPUs.\n");

Hehe, that's indeed what I inspired from ;-)
