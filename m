Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaEOEqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:46:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48525 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaEOEqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:46:22 -0400
Message-ID: <1400129178.5175.82.camel@marge.simpson.net>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 06:46:18 +0200
In-Reply-To: <20140515040608.GA3825@htj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
	 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
	 <20140501142414.GA31611@htj.dyndns.org>
	 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
	 <20140501210242.GA28948@mtj.dyndns.org>
	 <20140501210943.GB28948@mtj.dyndns.org> <537384B9.5090907@suse.cz>
	 <20140514151501.GA24142@suse.cz> <20140514163238.GA15690@htj.dyndns.org>
	 <1400126037.5175.55.camel@marge.simpson.net>
	 <20140515040608.GA3825@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 00:06 -0400, Tejun Heo wrote: 
> Hey, Mike.
> 
> On Thu, May 15, 2014 at 05:53:57AM +0200, Mike Galbraith wrote:
> > Hm.  The user would need to be able to identify and prioritize the
> 
> I suppose you mean userland by "the user"?

Yeah.

> > things, and have his settings stick.  Any dynamic pool business doing
> > allocations and/or munging priorities would be highly annoying.
> 
> There are some use cases where control over worker priority or other
> attributes are necessary.  I'm not sure using kthread for that reason
> is a good engineering choice tho.  Many of those cases end up being
> accidental.

It's currently the only option.  For perfection, you'd have to have fine
grained deterministic yada yada throughout all paths, which is kinda out
for generic proxies, but it's a hell of a lot better than no control.

> I think it'd be healthier to identify the use cases and then provide
> proper interface for it.  Note that workqueue can now expose interface
> to modify concurrency, priority and cpumask to userland which
> writeback workers are already using.

You can't identify a specific thing, any/all of it can land on the
user's diner plate, so he should be able to make the decisions.  Power
to the user and all that, if he does something stupid, tuff titty.  User
getting to call the shots, and getting to keep the pieces when he fscks
it all up is wonderful stuff, lets kernel people off the hook :)

-Mike

