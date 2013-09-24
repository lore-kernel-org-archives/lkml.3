Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3IXQvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3IXQvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:51:04 -0400
Date: Tue, 24 Sep 2013 18:44:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from
	may_change_ptraced_domain()
Message-ID: <20130924164442.GB4036@redhat.com>
References: <20130916142035.GA26661@redhat.com> <20130923215214.GV13968@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923215214.GV13968@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Richard Guy Briggs wrote:
>
> On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
> > Unless task == current ptrace_parent(task) is not safe even under
> > rcu_read_lock() and most of the current users are not right.
>
> Could you point to an explanation of this?

If this task exits before rcu_read_lock() ->parent can point to the
already freed/reused memory.

(in the long term we should probably clear
 ->parent/real_parent/group_leader/more in __unhash_process(), but
 lets not discuss this right now ;)

> (Did you send a patch to fix the selinux hook?)

No, sorry, I was sick. Will do.

> Acked-by: Richard Guy Briggs <rgb@redhat.com>

Thanks!

Oleg.

