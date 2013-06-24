Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3FXREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:04:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FXREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:04:38 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=xfBPjy3jFk37ySpaGwwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372093476.18733.170.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Mon, 24 Jun 2013 13:04:36 -0400
In-Reply-To: <20130624165140.GB8572@redhat.com>
References: <20130622173129.GA29375@redhat.com>
	 <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com>
	 <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com>
	 <20130624020014.GB12811@redhat.com> <20130624143928.GA20659@redhat.com>
	 <1372085549.18733.162.camel@gandalf.local.home>
	 <20130624160012.GB5993@redhat.com>
	 <1372091079.18733.168.camel@gandalf.local.home>
	 <20130624165140.GB8572@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 12:51 -0400, Dave Jones wrote:
> On Mon, Jun 24, 2013 at 12:24:39PM -0400, Steven Rostedt wrote:
> 
>  > > Ah, this is the first victim of my new 'check sanity of nodes during list walks' patch.
>  > > It's doing the same prev->next next->prev checking as list_add and friends.
>  > > I'm looking at getting it into shape for a 3.12 merge after some other preparatory patches
>  > > go into 3.11
>  > 
>  > OK, and you may need to make an exception for the ring buffer. To do a
>  > lockless swap out of the reader page for one of the pages in the buffer,
>  > it uses the 2 LSB as flags. Notice the "next=ffff880243288001", that "1"
>  > is a flag that states the next page is the "header" page (next to be
>  > read). We use cmpxchg to update the pages to handle races between the
>  > reader and writer.
> 
> I just had a plumber come visit to replace my toilet.
> I think even he would say "dude, gross" about that hack.
> 

Wow, that hack made you so sick you needed to replace your toilet?

Note, the idea of using the 2 LSB bits of pointers came from -rt. Where
we do the same with the rt_mutex owner.

-- Steve


