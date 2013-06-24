Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3FXQv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3FXQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:51:55 -0400
Date: Mon, 24 Jun 2013 12:51:40 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624165140.GB8572@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624020014.GB12811@redhat.com>
 <20130624143928.GA20659@redhat.com>
 <1372085549.18733.162.camel@gandalf.local.home>
 <20130624160012.GB5993@redhat.com>
 <1372091079.18733.168.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372091079.18733.168.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 12:24:39PM -0400, Steven Rostedt wrote:

 > > Ah, this is the first victim of my new 'check sanity of nodes during list walks' patch.
 > > It's doing the same prev->next next->prev checking as list_add and friends.
 > > I'm looking at getting it into shape for a 3.12 merge after some other preparatory patches
 > > go into 3.11
 > 
 > OK, and you may need to make an exception for the ring buffer. To do a
 > lockless swap out of the reader page for one of the pages in the buffer,
 > it uses the 2 LSB as flags. Notice the "next=ffff880243288001", that "1"
 > is a flag that states the next page is the "header" page (next to be
 > read). We use cmpxchg to update the pages to handle races between the
 > reader and writer.

I just had a plumber come visit to replace my toilet.
I think even he would say "dude, gross" about that hack.

	Dave

