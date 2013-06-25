Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3FYR0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3FYR0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:26:30 -0400
Date: Tue, 25 Jun 2013 13:26:09 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130625172609.GA17050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130623160452.GA11740@redhat.com>
 <20130624020014.GB12811@redhat.com>
 <20130624143928.GA20659@redhat.com>
 <1372085549.18733.162.camel@gandalf.local.home>
 <20130624160012.GB5993@redhat.com>
 <1372091079.18733.168.camel@gandalf.local.home>
 <20130624165140.GB8572@redhat.com>
 <1372093476.18733.170.camel@gandalf.local.home>
 <20130625165556.GA16170@redhat.com>
 <1372180890.18733.217.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372180890.18733.217.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 01:21:30PM -0400, Steven Rostedt wrote:
 > On Tue, 2013-06-25 at 12:55 -0400, Dave Jones wrote:
 > 
 > > While I've been spinning wheels trying to reproduce that softlockup bug,
 > > On another machine I've been refining my list-walk debug patch.
 > > I added an ugly "ok, the ringbuffer is playing games with lower two bits" special case.
 > > 
 > > But what the hell is going on here ?
 > > 
 > > next->prev should be prev (ffff88023c6cdd18), but was 00ffff88023c6cdd. (next=ffff880243288001).
 > > 
 > > (trace comes from the same ringbuffer code)
 > 
 > What's the above saying?  ffff880243288000->prev == 00ffff88023c6cdd but
 > it should have been ffff88023c6cdd18? That is: ffff88023c6cdd18->next ==
 > ffff880243288001?

It's saying something has done >>8 on a pointer, and stuck it in a list head.

 > Not sure how that would mess up. The ring-buffer code has lots of
 > integrity checks to make sure nothing like this breaks.

My integrity checks can beat up your integrity checks.

	Dav

