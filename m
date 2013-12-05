Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3LEOjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:39:11 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:35561 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3LEOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:39:07 -0500
Date: Thu, 5 Dec 2013 09:39:03 -0500
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131205143903.GA3231@htj.dyndns.org>
References: <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128142359.GA6420@redhat.com>
 <20131128143155.GC3925@htj.dyndns.org>
 <20131128150055.GA11956@redhat.com>
 <20131128150233.GA10022@twins.programming.kicks-ass.net>
 <20131128193330.GA24767@redhat.com>
 <20131128193349.GB24767@redhat.com>
 <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
 <20131205143745.GA18488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205143745.GA18488@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 05, 2013 at 03:37:45PM +0100, Oleg Nesterov wrote:
> > I'm adding Christophe in Cc because he is interested in tweaking the
> > affinity of call_usermodehelper for cpu isolation. This welcome
> > cleanup confirms that we want to take the direction of being able to
> > change the affinity of workqueue themselves instead of just
> > call_usermodehelper() alone.
> 
> OK, but I'd like to remind just in case, as Tejun pointed out this
> patch is wrong ;)
> 
> And "change the affinity of workqueue themselves" is not simple, but
> we can make khelper_wq WQ_SYSFS.

Maybe workqueue should implement and expose default attributes which
are inherited by all workqueues unless they're explicitly overridden?
The use case here is not really about isolating certain subgroup of
workers but rather being able to control the default behavior, right?

Thanks.

-- 
tejun
