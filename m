Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935382Ab3BTNcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:32:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab3BTNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:32:50 -0500
Message-ID: <1361367148.10155.30.camel@laptop>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 20 Feb 2013 14:32:28 +0100
In-Reply-To: <20130220104958.GA9152@gmail.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 11:49 +0100, Ingo Molnar wrote:

> The changes look clean and reasoable, 

I don't necessarily agree, note that O(n^2) storage requirement that
Michael failed to highlight ;-)

> any ideas exactly *why* it speeds up?

That is indeed the most interesting part.. There's two parts to
select_task_rq_fair(), the 'regular' affine wakeup path, and the
fork/exec find_idlest_goo() path. At the very least we need to quantify
which of these two parts contributes most to the speedup.

In the power balancing discussion we already noted that the
find_idlest_goo() is in need of attention.

