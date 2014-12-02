Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaLBRcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:32:33 -0500
Received: from mail.efficios.com ([78.47.125.74]:41934 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaLBRcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:32:32 -0500
Date: Tue, 2 Dec 2014 17:32:32 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <940407620.22325.1417541552737.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141202171102.GC10918@htj.dyndns.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org> <20141202164024.GA10918@htj.dyndns.org> <alpine.DEB.2.11.1412021049580.13039@gentwo.org> <20141202171102.GC10918@htj.dyndns.org>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.22.116]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF33 (Linux)/8.0.7_GA_6021)
Thread-Topic: Final per cpu consistency patch for -next or late in 3.19 merge period
Thread-Index: 04+lLnQDqVroUhgSeEFquu4GWDQNxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Tejun Heo" <htejun@gmail.com>
> To: "Christoph Lameter" <cl@linux.com>
> Cc: linux-kernel@vger.kernel.org, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Andrew Morton"
> <akpm@linux-foundation.org>
> Sent: Tuesday, December 2, 2014 12:11:02 PM
> Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge period
> 
> On Tue, Dec 02, 2014 at 10:57:50AM -0600, Christoph Lameter wrote:
> > On Tue, 2 Dec 2014, Tejun Heo wrote:
> > 
> > > Can you please update Documentation/local_ops.txt and comments which
> > > contain __get_cpu_var() and send the updated patch to Andrew?
> > 
> > Owww.... local_* ops are exotic operations that should no longer be
> > regularly used. This_cpu ops create less overhead and
> > are simpler to use. Lets merge the prior patch as is and then add this
> > documentation patch which may cause some additional discussion.
> 
> Sure, I just wanna make sure we don't have dangling references to
> __get_cpu_var() which no longer exists.  There are also a couple
> places where comment text refers to it.  Let's please take care of
> them too.

If I understand correctly, __get_cpu_var() is being deprecated ?
If this_cpu_ptr() is semantically equivalent to __get_cpu_var(), we can do a
wrapper in lttng-modules and move to the new name, no worries there.

Background:

LTTng-modules (out of tree) still uses __get_cpu_var() for our per-cpu
nesting counter (internal safety net), and our per-cpu last_tsc value
tracking since 3.17.

We also rely on local_t atomic operations to interact with each per-cpu
ring buffer. Since we already need to get the CPU number to know which
dynamically allocated ring buffer we need to work with, and since we're
always in preempt disabled context, there is not much gain in changing
the entire design to move from local_t ops to this_cpu() ops.

Thanks,

Mathieu


> 
> Thanks.
> 
> --
> tejun
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
