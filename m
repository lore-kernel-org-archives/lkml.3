Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3KLI0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:26:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3KLIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:25:55 -0500
Date: Tue, 12 Nov 2013 09:25:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: Re: [PATCH] [sched]: pick the NULL entity caused the panic.
Message-ID: <20131112082549.GH5056@laptop.programming.kicks-ass.net>
References: <1384273790.21369.15.camel@wxm-ubuntu>
 <CAPM31RLMT583XzP=VuToFpyd1irwfRZGQsbJdby7GaUhD4b_GA@mail.gmail.com>
 <FA47D36D6EC9FE4CB463299737C09B9901B6D847@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA47D36D6EC9FE4CB463299737C09B9901B6D847@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:38:24AM +0000, Wang, Xiaoming wrote:
> Dear Paul
> 	How about moving cfs_rq->nr_running into loop. What I worried is that cfs_rq->nr_running
> may zero because cfs_rq is coming from cfs_rq = group_cfs_rq(se) again. We haven't known the 
> reproduction exactly, panic happened only on random test and unstable. 

No; its just plain wrong. If this new condition can be true there's
something fundamentally messed up and we need to figure out what causes
that, not try and paper it over.

