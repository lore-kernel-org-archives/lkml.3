Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaGOSlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:41:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:44620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093AbaGOSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:41:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,667,1400050800"; 
   d="scan'208";a="573588414"
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140715120728.GR3588@twins.programming.kicks-ass.net>
References: <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
	 <1405367450.2970.750.camel@schen9-DESK>
	 <20140715095045.GV9918@twins.programming.kicks-ass.net>
	 <20140715120728.GR3588@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jul 2014 11:40:58 -0700
Message-ID: <1405449658.2970.797.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 14:07 +0200, Peter Zijlstra wrote:
> On Tue, Jul 15, 2014 at 11:50:45AM +0200, Peter Zijlstra wrote:
> > So you already have an idle notifier (which is x86 only, we should fix
> > that I suppose), and you then double check there really isn't anything
> > else running.
> 
> Note that we've already done a large part of the expense of going idle
> by the time we call that idle notifier -- in specific, we've
> reprogrammed the clock to stop the tick.
> 
> Its really wasteful to then generate work again, which means we have to
> again reprogram the clock etc.

Will try another version of the patch without using the idle notifier.

Tim

