Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaICPWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaICPWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:22:04 -0400
Date: Wed, 3 Sep 2014 17:18:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140903151848.GA6312@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com> <20140902173910.GF27892@worktop.ger.corp.intel.com> <20140903133640.GA25439@redhat.com> <20140903144450.GB7083@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903144450.GB7083@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Peter Zijlstra wrote:
>
> On Wed, Sep 03, 2014 at 03:36:40PM +0200, Oleg Nesterov wrote:
> >
> > 	// Ensure that the previous __set_current_state(RUNNING) can't
> > 	// leak after spin_unlock_wait()
> > 	smp_mb();
> > 	spin_unlock_wait();
> > 	// Another mb to ensure this too can't be reordered with unlock_wait
> > 	set_current_state(TASK_DEAD);
> >
> > What do you think looks better?
>
> spin_unlock_wait() would be a control dependency right? Therefore that
> store could not creep up anyhow.

Hmm. indeed, thanks! This probably means that task_work_run() can use
rmb() instead of mb().

What I can't understand is do we still need a compiler barrier or not.
Probably "in theory yes" ?

Oleg.

