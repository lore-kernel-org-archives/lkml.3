Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3HEJJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:09:06 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54812 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HEJJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:09:04 -0400
Date: Mon, 5 Aug 2013 11:08:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805090857.GA26940@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805083434.GA20606@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 05, 2013 at 10:31:32AM +0200, Ingo Molnar wrote:
>
> > Nonsense, a distro, if it truly worried about this, could create two 
> > packages already, there's no need to expose configuration options in 
> > the binary name itself and burden users with the separation. I 
> > sometimes switch the UI frontend of perf depending on the workflow and 
> > the terminal, it would be highly annoying if the binary name was 
> > changed to expose configuration options.
> 
> Which means you'd have to use a different tool name or have incompatible 
> packages, both of which aren't desirable.

You'd have alternative packages - i.e. the configuration and dependency 
difference is exposed in the packaging space, not in the user interface, 
command name space.

(and yes, gtk linking in 20+ libraries is suboptimal, hopefully that will 
eventually be fixed by the GTK project. If a leaner project with similarly 
good UI elements comes around we might switch to it - without having to 
rename the binary yet again.)

I.e. put the burden on packagers for too high library dependency 
complexity, not on end users. A fair deal by any count.

> > The thing is, you strongly objected to perf itself when we offered it 
> > up for an upstream merge and I'm not surprised you still don't like 
> > it.
> 
> I strongly objected to adding it to the kernel tree, and I still stand 
> to that opinion because it makes using perf much more painful than it 
> needs to be. [...]

That's still a red herring - 'using' perf for 99% of the users is to 
install the perf package or to type 'make install' ...

> [...]  I never disliked perf itself and use it frequently now that I can 
> bypass some of the pains by just using an older distro package.

If you have special needs you could lobby your distro for different 
versions - or you could build it from source.

Your solution, to split the binary into two parts, just to expose a 
configuration option you don't want to enable in certain uses, burdens the 
regular user of perf.

> But I'd much rather get this back to technical discussions than personal 
> attacks..

You never replied to the original counter-arguments, such as this one from 
Linus:

  http://article.gmane.org/gmane.linux.kernel/849965

Or this one from Andrew:

  http://article.gmane.org/gmane.linux.kernel/850067

so I assumed your (still arguably dishonest) objections are still valid 
and still broad - and are reflected in this thread.

That's not a personal attack by any means - we met before and I actually 
like you as a person, I just don't like your opinion here and I don't like 
your occasionally dishonest discussion style: because it only focuses on 
the narrow issue of packaging complexity and does not look at the bigger 
picture such as health of development and end user ease of use.

Thanks,

	Ingo
