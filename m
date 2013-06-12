Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3FLNH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:07:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3FLNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:07:25 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ycZEzXImLNUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=3pk_6Pr9cc8A:10 a=VMOMtQ9TVZxcMBCPvnYA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371042443.9844.255.camel@gandalf.local.home>
Subject: Re: [PATCH] spin_unlock*_no_resched()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de
Date: Wed, 12 Jun 2013 09:07:23 -0400
In-Reply-To: <20130612121532.GD3204@twins.programming.kicks-ass.net>
References: <1022041371038807@web30d.yandex.ru>
	 <20130612121532.GD3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 14:15 +0200, Peter Zijlstra wrote:

> So I absolutely hate this API because people can (and invariably will)
> abuse it; much like they did/do preempt_enable_no_resched().

Me too.

> 
> IIRC Thomas even maps preempt_enable_no_resched() to preempt_enable() in
> -rt to make sure we don't miss preemption points due to stupidity.
> 
> He converted the 'few' sane sites to use schedule_preempt_disabled(). In
> that vein, does it make sense to introduce schedule_spin_locked()?
> 

I was thinking the exact same thing when I read this patch. This is a
strict policy that we should enforce and not let individual developers
implement. Yes, a schedule_spin_unlock() would work nicely. The API will
enforce the two to be used together. Otherwise, I can envision seeing
things like:

	preempt_disable();
	[...]

	spin_lock(x);

	spin_unlock_no_resched(x);

	[...]

	preempt_enable();

And developers having no idea why the above is broken. Although, I would
say the above is broken for other reasons, but I was just using that to
show the craziness such an API would give to us.

-- Steve



