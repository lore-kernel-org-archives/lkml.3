Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab3FCDJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:09:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:58885 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3FCDJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:09:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+dtRUAlwidDayouz/Q1cfbXgnCMRwKWWC6ot3Gzn
	hWs/ax5cFWInIW
Message-ID: <1370228941.5988.66.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 03 Jun 2013 05:09:01 +0200
In-Reply-To: <51ABFF6A.60206@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51ABFF6A.60206@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 10:28 +0800, Michael Wang wrote: 
> On 05/28/2013 01:05 PM, Michael Wang wrote:
> > wake-affine stuff is always trying to pull wakee close to waker, by theory,
> > this will bring benefit if waker's cpu cached hot data for wakee, or the
> > extreme ping-pong case.
> > 
> > And testing show it could benefit hackbench 15% at most.
> > 
> > However, the whole stuff is somewhat blindly and time-consuming, some
> > workload therefore suffer.
> > 
> > And testing show it could damage pgbench 50% at most.
> > 
> > Thus, wake-affine stuff should be smarter, and realise when to stop
> > it's thankless effort.
> 
> Is there any comments?

(I haven't had time to test-drive yet, -rt munches time like popcorn)

