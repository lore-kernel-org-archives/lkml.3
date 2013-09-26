Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775Ab3IZNZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3IZNZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:25:24 -0400
Date: Thu, 26 Sep 2013 09:25:19 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from
 may_change_ptraced_domain()
Message-ID: <20130926132519.GY13968@madcap2.tricolour.ca>
References: <20130916142035.GA26661@redhat.com>
 <20130923215214.GV13968@madcap2.tricolour.ca>
 <20130924164442.GB4036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924164442.GB4036@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:44:42PM +0200, Oleg Nesterov wrote:
> On 09/23, Richard Guy Briggs wrote:
> >
> > On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
> > > Unless task == current ptrace_parent(task) is not safe even under
> > > rcu_read_lock() and most of the current users are not right.
> >
> > Could you point to an explanation of this?
> 
> If this task exits before rcu_read_lock() ->parent can point to the
> already freed/reused memory.

Ok, understood.  So even though the task may have exited, the task
struct pointer is still valid, but not the contents of the task struct
to which it points.

> (in the long term we should probably clear
>  ->parent/real_parent/group_leader/more in __unhash_process(), but
>  lets not discuss this right now ;)

...so that the contents are valid in a task struct of a task that has
exited.

Thanks for the (more obvious to me now) explanation.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
