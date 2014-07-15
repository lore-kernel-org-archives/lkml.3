Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbaGOSHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:07:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62489 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaGOSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:07:00 -0400
Message-ID: <1405447615.5117.36.camel@marge.simpson.net>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 20:06:55 +0200
In-Reply-To: <20140715145346.GM9918@twins.programming.kicks-ass.net>
References: <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
	 <1405367450.2970.750.camel@schen9-DESK>
	 <20140715095045.GV9918@twins.programming.kicks-ass.net>
	 <20140715120728.GR3588@twins.programming.kicks-ass.net>
	 <alpine.DEB.2.10.1407151452370.24854@nanos>
	 <1405435525.5744.29.camel@marge.simpson.net>
	 <20140715145346.GM9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 16:53 +0200, Peter Zijlstra wrote: 
> On Tue, Jul 15, 2014 at 04:45:25PM +0200, Mike Galbraith wrote:
> > 
> > 3.0.101-default        3.753363 usecs/loop -- avg 3.770737 530.4 KHz   1.000
> > 3.14.10-default        4.145348 usecs/loop -- avg 4.139987 483.1 KHz    .910     1.000
> > 3.15.4-default         4.355594 usecs/loop -- avg 4.351961 459.6 KHz    .866      .951    1.000
> > 3.16.0-default         4.537279 usecs/loop -- avg 4.543532 440.2 KHz    .829      .911     .957
> > 
> > 3.0.101-smp            3.692377 usecs/loop -- avg 3.690774 541.9 KHz   1.000
> > 3.14.10-smp            4.010009 usecs/loop -- avg 4.009019 498.9 KHz    .920
> > 3.15.4-smp             3.882398 usecs/loop -- avg 3.884095 514.9 KHz    .950
> > 3.16.0-master          4.061003 usecs/loop -- avg 4.058244 492.8 KHz    .909
> 
> Urgh,.. I need to go fix that :/

I'm poking about.  It's not just one thing 'course, just lots of change
adding up to less than wonderful.  Idle changes are costing some, for
obese config, avg goop.  The select_next_task() reorganization appears
to be costing, but eyeballing, I can see no excuse for that at all.

-Mike

