Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3JNSp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:45:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3JNSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:45:55 -0400
Date: Mon, 14 Oct 2013 20:45:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: Change uprobe_copy_process() to dup
 return_instances
Message-ID: <20131014184548.GG2675@laptop.programming.kicks-ass.net>
References: <20131013191815.GA32466@redhat.com>
 <20131013191841.GA32499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013191841.GA32499@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 09:18:41PM +0200, Oleg Nesterov wrote:
> uprobe_copy_process() assumes that the new child doesn't need
> ->utask, it should be allocated by demand.
> 
> But this is not true if the forking task has the pending ret-
> probes, the child should report them as well and thus it needs
> the copy of parent's ->return_instances chain. Otherwise the
> child crashes when it returns from the probed function.

So children don't automagically inherit the same probes (only though the
high level interface -- like perf), so wouldn't simply fixing up the
child stack be a solution?

If not; its not entirely clear to my why this isn't a good solution
based on these changelogs.
