Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3AVUy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:54:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3AVUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:54:26 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8XPjA_W9iWwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=cA-augn98TgA:10 a=KwsRBNIfCVfK20CjW1kA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358888061.21576.57.camel@gandalf.local.home>
Subject: Re: [PATCH v5 01/45] percpu_rwlock: Introduce the global
 reader-writer lock backend
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-doc@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rjw@sisk.pl,
        namhyung@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        oleg@redhat.com, sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Jan 2013 15:54:21 -0500
In-Reply-To: <50FEEF5D.6080302@linux.vnet.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
	 <20130122073315.13822.27093.stgit@srivatsabhat.in.ibm.com>
	 <1358883152.21576.55.camel@gandalf.local.home>
	 <50FEEF5D.6080302@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 01:28 +0530, Srivatsa S. Bhat wrote:

> > I thought global locks are now fair. That is, a reader will block if a
> > writer is waiting. Hence, the above should deadlock on the current
> > rwlock_t types.
> > 
> 
> Oh is it? Last I checked, lockdep didn't complain about this ABBA scenario!

It doesn't and Peter Zijlstra said we need to fix that ;-)  It only
recently became an issue with the new "fair" locking of rwlocks.

-- Steve


