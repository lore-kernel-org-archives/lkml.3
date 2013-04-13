Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3DMSh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:37:58 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46935 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3DMSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:37:57 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 13 Apr 2013 11:37:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/8] RCU callback-numbering simplifications
 for 3.11
Message-ID: <20130413183745.GD12096@leaf>
References: <20130412233211.GA20993@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412233211.GA20993@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:32:11PM -0700, Paul E. McKenney wrote:
> This series takes advantage of callback numbering to simplify RCU's
> grace-period machinery, in some cases also reducing the number of
> lock acquisitions (though the resulting change in performance is not
> perceptible).  The individual patches are as follows:
> 
> 1.	Move code to make way for the code-combining in later patches.
> 	This commit makes no changes, just moves code.
> 
> 2.	Make __note_new_gpnum() also check for the ends of prior grace
> 	periods, thus eliminating the earlier possibility of a given
> 	CPU becoming aware of the start of the next grace period before
> 	becoming aware of the end of the previous grace period.  Yes,
> 	the code did handle this correctly, but now it doesn't need to.
> 	More important, now I don't need to think about how it handles
> 	this correctly.
> 
> 3.	Rename note_new_gpnum() to note_gp_changes() in preparation for
> 	later merge of rcu_process_gp_end() into this function.
> 
> 4.	Change calls to rcu_process_gp_end() to instead call
> 	note_gp_changes(), and also remove the now-used rcu_process_gp_end().
> 
> 5.	Remove duplicate code by merging __rcu_process_gp_end() into
> 	__note_gp_changes().
> 
> 6.	Eliminate now-redundant call to check_for_new_grace_period().  This
> 	leaves only a single caller, so inline check_for_new_grace_period().
> 
> 7.	Given that rcu_start_gp_per_cpu() is a trivial wrapper function
> 	with only one caller, inline it into its sole remaining call site.
> 
> 8.	Eliminate now-redundant call to note_gp_changes().

For all 8:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
