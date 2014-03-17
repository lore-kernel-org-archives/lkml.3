Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaCQUQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaCQUQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:16:02 -0400
Message-ID: <1395087329.10287.33.camel@localhost>
Subject: Re: [PATCH 7/7] pid: get pid_t ppid of task in init_pid_ns
From: Eric Paris <eparis@redhat.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sgrubb@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 17 Mar 2014 16:15:29 -0400
In-Reply-To: <CA+8MBbLczQQdDrQSjWvpxVF7yJr4p5TVxTSsg5HtBngw+=CmmA@mail.gmail.com>
References: <cover.1390495874.git.rgb@redhat.com>
	 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
	 <328c85752a7eb053e72d9194827b91fc228d4f67.1390495874.git.rgb@redhat.com>
	 <CA+8MBbLczQQdDrQSjWvpxVF7yJr4p5TVxTSsg5HtBngw+=CmmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 13:14 -0700, Tony Luck wrote:
> On Thu, Jan 23, 2014 at 11:32 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Added the functions task_ppid_nr_ns() and task_ppid_nr() to abstract the lookup
> > of the PPID (real_parent's pid_t) of a process, including rcu locking, in the
> > arbitrary and init_pid_ns.
> > This provides an alternative to sys_getppid(), which is relative to the child
> > process' pid namespace.
> ...
> > +static int pid_alive(const struct task_struct *p);
> 
> This patch (or some successor version of it) showed up
> in next-20140317 and the above declaration caused a
> bunch of warnings on ia64:
> 
> include/linux/sched.h:1718: warning: 'pid_alive' declared inline after
> being called
> 
> [repeated 1675 times across files that include this]
> 
> The ia64 complier is a lot happier if "inline" is added like this:
> 
> static inline int pid_alive(const struct task_struct *p);

Fixed for tomorrow.

