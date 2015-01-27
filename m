Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbbA0TSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:18:38 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:38014 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbbA0TSh (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 27 Jan 2015 14:18:37 -0500
Message-ID: <1422386304.4604.4.camel@stgolabs.net>
Subject: Re: [PATCH 3/6] locking/rwsem: Set lock ownership ASAP
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 11:18:24 -0800
In-Reply-To: <20150127171021.GJ21418@twins.programming.kicks-ass.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-4-git-send-email-dave@stgolabs.net>
	 <20150127171021.GJ21418@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 18:10 +0100, Peter Zijlstra wrote:
> This is the thing I suggested
> lkml.kernel.org/r/20150108103708.GE29390@twins.programming.kicks-ass.net
> there right?

Yeah.

> Do you have numbers for how much this gained?

This is more of a correctness patch, nothing really tangible for
performance -- although I did note a 5% tp increase as that particular
workload, as pounds on the osq so we have to wait for the node->next
pointer. Otherwise, the window between when we set the lock is taken and
owner is set is very small.

Thanks,
Davidlohr


