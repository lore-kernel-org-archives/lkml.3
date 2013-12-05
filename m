Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3LEP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:29:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab3LEP3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:29:39 -0500
Date: Thu, 5 Dec 2013 16:30:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131205153016.GA20705@redhat.com>
References: <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com> <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com> <20131205143745.GA18488@redhat.com> <20131205143903.GA3231@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205143903.GA3231@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/05, Tejun Heo wrote:
> Hello,
>
> On Thu, Dec 05, 2013 at 03:37:45PM +0100, Oleg Nesterov wrote:
> >
> > OK, but I'd like to remind just in case, as Tejun pointed out this
> > patch is wrong ;)
> >
> > And "change the affinity of workqueue themselves" is not simple, but
> > we can make khelper_wq WQ_SYSFS.
>
> Maybe workqueue should implement and expose default attributes which
> are inherited by all workqueues unless they're explicitly overridden?
> The use case here is not really about isolating certain subgroup of
> workers but rather being able to control the default behavior, right?

Perhaps, I simply do not know what the users want.

Either way, if khelper_wq will be controlled by sysfs, then this
set_cpus_allowed_ptr() should probably die.

Oleg.

