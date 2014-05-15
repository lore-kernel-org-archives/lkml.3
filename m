Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaEOFJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:09:20 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36847 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaEOFJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:09:18 -0400
Date: Thu, 15 May 2014 01:09:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140515050915.GA5539@mtj.dyndns.org>
References: <20140501210242.GA28948@mtj.dyndns.org>
 <20140501210943.GB28948@mtj.dyndns.org>
 <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
 <20140514163238.GA15690@htj.dyndns.org>
 <1400126037.5175.55.camel@marge.simpson.net>
 <20140515040608.GA3825@htj.dyndns.org>
 <1400129178.5175.82.camel@marge.simpson.net>
 <20140515045011.GB3825@htj.dyndns.org>
 <1400130262.5175.93.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400130262.5175.93.camel@marge.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Thu, May 15, 2014 at 07:04:22AM +0200, Mike Galbraith wrote:
> On Thu, 2014-05-15 at 00:50 -0400, Tejun Heo wrote: 
> > Do we know specific kthreads which need to be exposed with this way?
> 
> Soft/hard irq threads and anything having to do with IO mostly, which
> including workqueues.  I had to give the user a rather fugly global
> prioritization option to let users more or less safely do the evil deeds
> they want to and WILL do whether I agree with their motivation to do so
> or not.  I tell all users that realtime is real dangerous, but if they
> want to do that, it's their box, so by definition perfectly fine.

Frederic is working on global settings for workqueues, so that'll
resolve some of those issues at least.

> > If there are good enough reasons for specific ones, sure, but I don't
> > think "we can't change any of the kthreads because someone might be
> > diddling with it" is something we can sustain in the long term.
> 
> I think the opposite.  Taking any control the user has is pure evil.

I'm not sure good/evil is the right frame to think about it.  Is
pooling worker threads evil in nature then?  Even when not doing so
leads to serious scalibilty issues and general poor utilization of
system resources?  User control, just like everything else, is one of
the many aspects to be evaluated and traded off, not something to
uphold religiously at all cost.

Thanks.

-- 
tejun
