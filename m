Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3BVIVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:21:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3BVIVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:21:23 -0500
Message-ID: <1361521270.26780.34.camel@laptop>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 09:21:10 +0100
In-Reply-To: <5126D9A2.8090404@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361427108.5861.41.camel@marge.simpson.net>
	 <5125C607.8090909@linux.vnet.ibm.com>
	 <1361434231.5861.61.camel@marge.simpson.net>
	 <5125E40D.6050006@linux.vnet.ibm.com>
	 <1361439789.5861.70.camel@marge.simpson.net>
	 <5126D9A2.8090404@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 10:36 +0800, Michael Wang wrote:
> According to my understanding, in the old world, wake_affine() will
> only
> be used if curr_cpu and prev_cpu share cache, which means they are in
> one package, whatever search in llc sd of curr_cpu or prev_cpu, we
> won't
> have the chance to spread the task out of that package.

Nah, look at where SD_WAKE_AFFINE is set. Only 'remote/big' NUMA domains
don't have it set, but 'small' NUMA systems will have it set over the
entire domain tree.



