Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3CGIg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:36:28 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46220
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab3CGIg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:36:27 -0500
Message-ID: <1362645372.2606.11.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 07 Mar 2013 09:36:12 +0100
In-Reply-To: <5136EB06.2050905@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:

> wake_affine() stuff is trying to bind related tasks closely, but it doesn't
> work well according to the test on 'perf bench sched pipe' (thanks to Peter).

so sched-pipe is a poor benchmark for this.. 

Ideally we'd write a new benchmark that has some actual data footprint
and we'd measure the cost of tasks being apart on the various cache
metrics and see what affine wakeup does for it.

Before doing something like what you're proposing, I'd have a hard look
at WF_SYNC, it is possible we should disable/fix select_idle_sibling
for sync wakeups.

The idea behind sync wakeups is that we try and detect the case where
we wakeup up one task only to go to sleep ourselves and try and avoid
the regular ping-pong this would otherwise create on account of the
waking task still being alive and so the current cpu isn't actually
idle yet but we know its going to be idle soon.



