Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3GPCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:09:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab3GPCJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:09:58 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=4fnmUe_o-lTAl6ZDmPcA:9 a=QEXdDO2ut3YA:10 a=s63Zvm6LGvzMyHRQ:21 a=Xpb5ZfbhSCX1gdlY:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373940594.17876.241.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 22:09:54 -0400
In-Reply-To: <20130716000623.GB26261@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <1373925699.17876.218.camel@gandalf.local.home>
	 <20130716000623.GB26261@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 17:06 -0700, Greg KH wrote:

> Maintainers are our most limited resource, I'm getting their "ack" when
> they themselves tag the patch to be backported with the Cc: line.

I find stable maintainers even more limited.

I'm not sure our maintainers are the most limited resource, we just have
the few that have proved themselves and it's hard to find people we
trust to expand. There's plenty of good people out there to help, but
the issue is more trust than anything else.

> 
> I then cc: them when the patch goes into the patch queue.
> 
> I then cc: them again when the patch is in the -rc1 phase.
> 
> How many times do I need to do this to give people a chance to say
> "nak"?

It can be missed by a big INBOX. Or put off till a later time that never
comes. The issue is that the default is to go in unless there is a
complaint, but if the maintainer needs to acknowledge before it goes
further, then it goes in when the maintainer is ready, not a short time
after it gets pulled into Linus's tree.

If the maintainer wants some patches to spend a bit of time in Linus's
tree before going to stable, then they need to not put the stable tag on
them, and manually do the work. Which may end up never going to stable
in the first place.

> 
> > The big problem with the above is that the process depends highly on
> > this guy named "Greg".
> > 
> > If "Greg" gets tired of doing this, or gets sick, or "see other KS topic
> > about mortality of maintainers", then the entire process fails.
> 
> "Greg" has documented how he does all of this work, and the scripts I
> use are all published as well.
> 
> "Greg" has also asked for help with all of this, a number of times, with
> a specific list of things that he needs help with.  And almost no one
> has ever offered to help.  That's fine, I can live with that, we all
> have jobs to do in other areas, and the LF now lets me do this as part
> of my job, so I can focus on it.

This is exactly my point. "Greg"'s problem is that he does too good of a
job at this. People look at what "Greg" does and say "he must be a God"
and start worshiping Him. I'm sure there are distros of people that have
sacrificed the sacred gecko in a burning altar chanting the subjects of
the stable patch bombs "Greg" does every week, praying that next week
there will come another holy trinity of the three stable releases "Greg"
maintains.

> 
> > OK, you are not the only one that does the stable release. There's Ben
> > and Luis doing it as well, and various others. But there seems to be a
> > bit of an issue here. How much should go into stable? Who really
> > decides?
> 
> The subsystem maintainers do by tagging the patches.  Every once in a
> while I dig stuff up on my own, but again, I give the subsystem
> maintainer at least two separate chances to NAK the patch, so it's not
> like I'm doing anything in private here.

It's not about doing it in private. But there seems to be some questions
about what should and should not be tagged stable. And the worse thing
that can happen is that a stable patch causes a regression in the stable
tree.

> 
> > How important is the stable releases? Are maintainers willing to do a
> > little more work now to make sure their subsystems work fine in older
> > kernels? This isn't the same stable as it was 8 years ago.
> 
> And that annoys the hell out of some Linux companies who feel that the
> stable kernels compete with them.  So people working for those companies
> might not get as much help with doing any additional work for stable
> kernel releases (this is not just idle gossip, I've heard it directly
> from management's mouths.)

Hmm, this is new to me. Really, I thought the whole point of the stable
releases was to help Linux companies.


> 
> So I need to, for both a resource management issue, and a business
> issue, make this as painless for maintainers as possible, which I have
> tried to do.
> 
> And given the uptick in the past few years of maintainers tagging
> patches, I think it's worked out so well that people are now doing it
> too much, which gets back to my original complaints last week that I am
> now working to address in a different manner.

Well, the final decision hangs with you and Linus. But would be good to
talk about this at Kernel Summit anyway. From other comments in the
thread, it looks like this will definitely be a topic there.

-- Steve


