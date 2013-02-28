Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3B1HXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:23:49 -0500
Received: from mout.gmx.net ([212.227.17.22]:58003 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3B1HXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:23:48 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 02:23:47 EST
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UR/IqDoXUb0oYKXVfH7r3yhfcQejHxxW/BymUO2
	/hpoKQX0SWLUCd
Message-ID: <1362035917.4460.105.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 28 Feb 2013 08:18:37 +0100
In-Reply-To: <512EFB4B.5040204@linux.vnet.ibm.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 14:38 +0800, Michael Wang wrote:

> +				/*
> +				 * current is the only task on rq and it is
> +				 * going to sleep, current cpu will be a nice
> +				 * candidate for p to run on.
> +				 */

The sync hint only means it might be going to sleep soon, and even then,
there can still be enough execution overlap to be a win to schedule
cross core.  Sched pipe numbers will always be much prettier if you do
wakeup cpu affine, as it's ~100% scheduler and ~100% sync.  You may lose
a lot on other stuff if you interpret the hint as gospel truth.

IMHO, sched pipe is a "how fat have I become" benchmark, not "how well
do I perform".  The scheduler performs well when it makes more work
happen.  Playing ping-pong with yourself is _exercise_, not a job :)

-Mike

