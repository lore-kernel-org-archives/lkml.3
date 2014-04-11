Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaDKCub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:50:31 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45885 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaDKCu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:50:29 -0400
Message-ID: <1397184626.5139.24.camel@marge.simpson.net>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 11 Apr 2014 04:50:26 +0200
In-Reply-To: <1397140123.5137.99.camel@marge.simpson.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	 <1397139510.5137.92.camel@marge.simpson.net>
	 <1397140123.5137.99.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, there was another useful bit. 

3.12.17-rt25       403991     384216     377786
                   405466     394011     392850

3.12.17-nopreempt  109049     186133     118766  !?!.. ew, TTWU_QUEUE
                   350385     318786     367336  !TTWU_QUEUE
                   326009     356939     378215  !TTWU_QUEUE

IPI == low-pass filter.

-Mike

