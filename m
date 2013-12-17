Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3LQJe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:34:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LQJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:34:54 -0500
Date: Tue, 17 Dec 2013 10:34:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20131217093442.GE21999@twins.programming.kicks-ass.net>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822190848.GA25053@redhat.com>
 <20130826220711.GA21098@madcap2.tricolour.ca>
 <20131216173547.GA21582@madcap2.tricolour.ca>
 <20131216210558.GA8565@redhat.com>
 <20131216222051.GA21056@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216222051.GA21056@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 05:20:51PM -0500, Richard Guy Briggs wrote:

 >  static inline bool is_idle_task(const struct task_struct *p)
 >  {
 > -	return p->pid == 0;
 > +	return task_pid(p) == &init_struct_pid;
 >  }

> I'll stick with task_pid_nr(p) == 0.

We're going to probably switch to:

  return p->flags & PF_IDLE;

Soon, because people are playing silly tricks and want normal threads
to temporarily appear to be the idle thread (idle time injection).
