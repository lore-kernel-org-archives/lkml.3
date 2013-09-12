Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3ILGD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:03:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3ILGD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:03:57 -0400
Message-ID: <1378965701.10696.36.camel@marge.simpson.net>
Subject: Re: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 08:01:41 +0200
In-Reply-To: <1378906497.5476.97.camel@marge.simpson.net>
References: <20130910130811.507933095@infradead.org>
	 <20130910132011.116593485@infradead.org> <522FCE9D.4010707@amacapital.net>
	 <20130911082530.GN31370@twins.programming.kicks-ass.net>
	 <20130911110635.GT26785@twins.programming.kicks-ass.net>
	 <1378906497.5476.97.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+t4FwQXyKfvtnBEz4x6sLziqHRDEkIQmMSIB8NO6u4C
 aclPcwZm3ENXhfbIhTlKoDwmxiS6/w2GAiU42hdEeozherqtw2
 KfQZSPMGRq/cmCJS6pxlK/u7yney/CQ/iAo1DeAoCRbJ17H7n1
 8EY5yYSaDqYr4qa4ZomAqKfnf6zAmTrMo80g7IgLL8/mk8fhlT
 a3CvG7l46br92BDH9k8bM9HgLPymVtjtMB2I7bj18gg8VmWYLr
 8cnslTn4FNcAQnP5vU59s4DZebF3Ca7qOvtRerK0ifshAp85yT
 tSXiN+Q4r3woNWtQnDWFqFoYHnedxLXklXtP8oB2CVwGxMB/Ci
 oeTO/pXrsjg8ivM/PEZ2/tIuLp6B/8IU5LSmlIlDzyz0+GhhKH
 jIcUjhVkDMxDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 15:34 +0200, Mike Galbraith wrote: 
> On Wed, 2013-09-11 at 13:06 +0200, Peter Zijlstra wrote: 

> > Mike does it fix the funny you saw?
> 
> Yup, modulo test_need_resched() not existing in master.

...

> while I haven't yet booted Q6600 box, core2
> Toshiba Satellite lappy is using mwait_idle_with_hints() in master.

Heh.  Core2 lappy uses mwait_idle_with_hints().. unless you boot
processor.max_cstate=1 so it doesn't use piece of shite hpet.  Q6600
always has idle woes, seemingly because box doesn't do deep enough
cstate to make something (acpi?) happy, despite mwait_idle() having
worked fine for years.

Seems I need to find the cstate dependency spot, and rap it upside the
head if I want my core2 boxen to regain happy campers status.

-Mike

