Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3FXQBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3FXQBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:01:42 -0400
Date: Mon, 24 Jun 2013 12:00:12 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624160012.GB5993@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624020014.GB12811@redhat.com>
 <20130624143928.GA20659@redhat.com>
 <1372085549.18733.162.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372085549.18733.162.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:52:29AM -0400, Steven Rostedt wrote:
 
 > > >  check_list_nodes corruption. next->prev should be prev (ffff88023b8a1a08), but was 00ffff88023b8a1a. (next=ffff880243288001).
 > > 
 > > Can't find "check_list_nodes" in lib/list_debug.c or elsewhere...
 > > 
 > > >   [<ffffffff816e467d>] dump_stack+0x19/0x1b
 > > >   [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
 > > >   [<ffffffff8104a12c>] warn_slowpath_fmt+0x4c/0x50
 > > >   [<ffffffff81112c61>] rb_head_page_deactivate.isra.39+0x61/0x80
 > > 
 > > How? rb_list_head_clear() just modifies list->next directly.
 > > 
 > > > hopefully despite that it'll actually function as intended.
 > > 
 > > Yes ;)
 > 
 > I'm curious to what happened.

Ah, this is the first victim of my new 'check sanity of nodes during list walks' patch.
It's doing the same prev->next next->prev checking as list_add and friends.
I'm looking at getting it into shape for a 3.12 merge after some other preparatory patches
go into 3.11

	Dave

