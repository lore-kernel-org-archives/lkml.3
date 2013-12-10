Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3LJPzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:55:55 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55828 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3LJPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:55:49 -0500
Date: Tue, 10 Dec 2013 16:55:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
Message-ID: <20131210155546.GD1995@gmail.com>
References: <20131203233232.928771708@linux.com>
 <20131203233251.745099192@linux.com>
 <20131210153445.GE4610@htj.dyndns.org>
 <20131210154506.GA1884@gmail.com>
 <20131210154951.GF4610@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210154951.GF4610@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Tue, Dec 10, 2013 at 04:45:06PM +0100, Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > > On Tue, Dec 03, 2013 at 05:32:45PM -0600, Christoph Lameter wrote:
> > > > The patches following this one will add preemption checks to __this_cpu
> > > > ops so we need to have an alternative way to use this_cpu operations
> > > > without preemption checks.
> > > > 
> > > > raw_cpu_ops will be the basis for all other ops since these will be the
> > > > operations that do not implement any checks. 
> > > > 
> > > > Primitive operations are renamed by this patch from __this_cpu_xxx to
> > > > raw_cpu_xxxx.
> > > > 
> > > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > > 
> > > Applied to percpu/for-3.14.
> > 
> > Please also pick up the related debugging bits:
> > 
> >    [PATCH 18/41] percpu: Add preemption checks to __this_cpu ops
> > 
> > as we don't want to expand percpu ops without doing proper debugging.
> 
> Yeah, trying to figure out which should go through which tree. 
> Christoph, should I also pickup 14?  Or can that go through x86?

Well, it appears to have dependencies so I doubt it can be kept 
separate. In any case, provided all debugging is properly productized:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
