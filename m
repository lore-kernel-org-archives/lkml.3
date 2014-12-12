Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967537AbaLLL57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:57:59 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:50311 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966268AbaLLL55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
Date: Fri, 12 Dec 2014 17:27:56 +0530
Message-ID: <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Thomas as well..

On 12 December 2014 at 01:12, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Viresh,
>
> We noticed the below lockup regression on commit 2a16fc93d2c ("nohz:
> Avoid tick's double reprogramming in highres mode").
>
> testbox/testcase/testparams: ivb42/idle-inject/60s-200%-10cp
>
> b5e995e671d8e4d7  2a16fc93d2c9568e16d45db77c
> ----------------  --------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :5          100%           1:1     last_state.is_incomplete_run
>            :5          100%           1:1     last_state.running
>
> testbox/testcase/testparams: lkp-sb03/idle-inject/60s-200%-10cp
>
> b5e995e671d8e4d7  2a16fc93d2c9568e16d45db77c
> ----------------  --------------------------
>            :7          100%           1:1     last_state.is_incomplete_run
>            :7          100%           1:1     last_state.running
>
> Where test box ivb42 is Ivy Bridge-EP and lkp-sb03 is Sandy Bridge-EP.
>
> To reproduce:
>
>         apt-get install ruby ruby-oj
>         git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>         cd lkp-tests
>         bin/setup-local job.yaml # the job file attached in this email
>         bin/run-local   job.yaml
>
> Basically what the test case does is to
>
> - find a Sandy Bridge or newer machine
> - look for a cooling device with type “intel_powerclamp”
> - set cur_state to 10
> - run any CPU extensive workload
>
> Then expect soft lockup. It's very reproducible.

Thanks Fengguang. Yes I am able to reproduce it, but don't know yet what
went wrong..

--
viresh
