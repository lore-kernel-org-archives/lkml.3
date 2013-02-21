Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3BUJnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:43:25 -0500
Received: from mout.gmx.net ([212.227.17.21]:60211 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3BUJnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:43:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+lz+9md0ulN6W4JslrUtwPJo3o7lMawD0WpDRxCn
	GfD9wmE0B6oJcQ
Message-ID: <1361439789.5861.70.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 21 Feb 2013 10:43:09 +0100
In-Reply-To: <5125E40D.6050006@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361427108.5861.41.camel@marge.simpson.net>
	 <5125C607.8090909@linux.vnet.ibm.com>
	 <1361434231.5861.61.camel@marge.simpson.net>
	 <5125E40D.6050006@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 17:08 +0800, Michael Wang wrote:

> But is this patch set really cause regression on your Q6600? It may
> sacrificed some thing, but I still think it will benefit far more,
> especially on huge systems.

We spread on FORK/EXEC, and will no longer will pull communicating tasks
back to a shared cache with the new logic preferring to leave wakee
remote, so while no, I haven't tested (will try to find round tuit) it
seems  it _must_ hurt.  Dragging data from one llc to the other on Q6600
hurts a LOT.  Every time a client and server are cross llc, it's a huge
hit.  The previous logic pulled communicating tasks together right when
it matters the most, intermittent load... or interactive use.

-Mike

