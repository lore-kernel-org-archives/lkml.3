Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3BRQbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:31:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3BRQbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:31:31 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=o2Q8bu201zMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=90TB_Sdg_p4A:10 a=CRI1Dda8Ao7ugpeRgCQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361205087.23152.159.camel@gandalf.local.home>
Subject: Re: [PATCH v6 04/46] percpu_rwlock: Implement the core design of
 Per-CPU Reader-Writer Locks
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>, tglx@linutronix.de,
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
Date: Mon, 18 Feb 2013 11:31:27 -0500
In-Reply-To: <5122551E.1080703@linux.vnet.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
	 <20130218123856.26245.46705.stgit@srivatsabhat.in.ibm.com>
	 <CANN689F9S7c1M8+cEpz3tsxGF34+NTRBLvxgPUOtbvav5u+RRA@mail.gmail.com>
	 <5122551E.1080703@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 21:51 +0530, Srivatsa S. Bhat wrote:
> Hi Michel,

> Yes.. I don't think we can avoid that. Moreover, since we _want_ unfair
> reader/writer semantics to allow flexible locking rules and guarantee
> deadlock-safety, having a recursive reader side is not even an issue, IMHO.

Recursive unfair reader lock may guarantee deadlock-safety, but
remember, it adds a higher probability of live-locking the write_lock.
Which is another argument to keep this separate to cpu hotplug only.

-- Steve


