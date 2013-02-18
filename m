Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3BRQsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:48:16 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60548 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3BRQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:48:12 -0500
Message-ID: <51225ACD.3080100@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 22:16:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Michel Lespinasse <walken@google.com>, tglx@linutronix.de,
        peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vincent.guittot@linaro.org
Subject: Re: [PATCH v6 04/46] percpu_rwlock: Implement the core design of
 Per-CPU Reader-Writer Locks
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <20130218123856.26245.46705.stgit@srivatsabhat.in.ibm.com> <CANN689F9S7c1M8+cEpz3tsxGF34+NTRBLvxgPUOtbvav5u+RRA@mail.gmail.com> <5122551E.1080703@linux.vnet.ibm.com> <1361205087.23152.159.camel@gandalf.local.home>
In-Reply-To: <1361205087.23152.159.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021816-8878-0000-0000-000005F06EBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 10:01 PM, Steven Rostedt wrote:
> On Mon, 2013-02-18 at 21:51 +0530, Srivatsa S. Bhat wrote:
>> Hi Michel,
> 
>> Yes.. I don't think we can avoid that. Moreover, since we _want_ unfair
>> reader/writer semantics to allow flexible locking rules and guarantee
>> deadlock-safety, having a recursive reader side is not even an issue, IMHO.
> 
> Recursive unfair reader lock may guarantee deadlock-safety, but
> remember, it adds a higher probability of live-locking the write_lock.
> Which is another argument to keep this separate to cpu hotplug only.
> 

True.
 
Regards,
Srivatsa S. Bhat

