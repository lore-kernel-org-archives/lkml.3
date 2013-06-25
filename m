Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FYRfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3FYRfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:35:08 -0400
Date: Tue, 25 Jun 2013 13:34:51 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130625173451.GB17050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130624020014.GB12811@redhat.com>
 <20130624143928.GA20659@redhat.com>
 <1372085549.18733.162.camel@gandalf.local.home>
 <20130624160012.GB5993@redhat.com>
 <1372091079.18733.168.camel@gandalf.local.home>
 <20130624165140.GB8572@redhat.com>
 <1372093476.18733.170.camel@gandalf.local.home>
 <20130625165556.GA16170@redhat.com>
 <1372180890.18733.217.camel@gandalf.local.home>
 <1372181394.18733.222.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372181394.18733.222.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 01:29:54PM -0400, Steven Rostedt wrote:
 > On Tue, 2013-06-25 at 13:21 -0400, Steven Rostedt wrote:
 > > On Tue, 2013-06-25 at 12:55 -0400, Dave Jones wrote:
 > > 
 > > > While I've been spinning wheels trying to reproduce that softlockup bug,
 > > > On another machine I've been refining my list-walk debug patch.
 > > > I added an ugly "ok, the ringbuffer is playing games with lower two bits" special case.
 > > > 
 > > > But what the hell is going on here ?
 > > > 
 > > > next->prev should be prev (ffff88023c6cdd18), but was 00ffff88023c6cdd. (next=ffff880243288001).
 > 
 > Ah you didn't handle the bit set case. I just noticed "00" in
 > 00ffff88023c6cdd. To test this, you really need to do a "next & ~3", to
 > clear the pointer.
 > 
 > Perhaps its best to have just a "raw_list_for_each" that doesn't do any
 > check, and have the ring buffer use that instead. The
 > rb_head_page_deactivate() is usually followed by an integrity check
 > anyway.

I think that's probably the best way forward. The ring buffer code does
so many weird things with list heads that it's almost it's own ADT.

	Dave

