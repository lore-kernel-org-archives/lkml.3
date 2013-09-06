Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3IFMlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3IFMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:41:06 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Pg0uVeabA7wA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RZDpadHLlpEA:10 a=3nbZYyFuAAAA:8 a=3dYWILzd2BM54esBrhkA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 08:41:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
Message-ID: <20130906084104.2c1e8774@gandalf.local.home>
In-Reply-To: <5229C8F7.7060000@hitachi.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
	<ecf9ba5f924d48eb6517c27d5e64044f827dd9d2.1378176577.git.tom.zanussi@linux.intel.com>
	<20130905120111.4900aa60@gandalf.local.home>
	<5229C8F7.7060000@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013 21:22:15 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> 
> And AFAICS, the tracepoint (on which the syscall tracer based)
> call-site uses rcu_read_lock_sched_notrace() instead of rcu_read_lock(),
> in that case, I think we should use synchronize_sched(). is that wrong?
> 

Ah, no, you are correct.  I was thinking that the tracepoints used
rcu_read_lock(), but looking at the code, it's rcu_read_lock_sched().
Thus a synchronize_sched() *is* required.

Thanks, and please ignore my other comments about using
"synchronize_rcu()".

-- Steve

