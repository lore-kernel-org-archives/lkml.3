Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3IISgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3IISgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:36:41 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=gOrCO-VQRb9PR5kAWWsA:9 a=CjuIK1q_8ugA:10 a=iZ7TXPg_hGsA:10 a=KxqS7gh_mc4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 14:36:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909143639.66ba6c7c@gandalf.local.home>
In-Reply-To: <20130909175656.GF3966@linux.vnet.ibm.com>
References: <20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909134505.GF16280@somewhere>
	<20130909135656.GT3966@linux.vnet.ibm.com>
	<20130909101629.32df27a2@gandalf.local.home>
	<20130909161708.GX3966@linux.vnet.ibm.com>
	<20130909123422.7936e868@gandalf.local.home>
	<20130909165836.GB3966@linux.vnet.ibm.com>
	<20130909172908.GA31239@Krystal>
	<20130909175656.GF3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 10:56:56 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> Although I do like rcu_is_active() better than rcu_read_check(), my
> concern with rcu_is_active() is that it can easily be mistaken for a
> global state rather than a per-CPU/thread/task/whatever state.

rcu_is_active_local();

Although, even though it's cute. I think "rcu_is_watching_you()" has no
ambiguity.

-- Steve
