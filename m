Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3KUPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:20:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3KUPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:20:56 -0500
Date: Thu, 21 Nov 2013 12:05:24 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121150524.GA24806@ghostprotocols.net>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121120605.GC26009@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 21, 2013 at 01:06:05PM +0100, Borislav Petkov escreveu:
> On Thu, Nov 21, 2013 at 12:42:24PM +0100, Ingo Molnar wrote:
> > ... and just in case you are wondering why I'm making a fuss about it:
> > a naming discussion for something fundamental as this isn't bikeshed
> > painting, we really want people to look at that place to readily
> > stuff kernel related helpers into, and the name should make that very
> > obvious.
 
> No, I absolutely don't think it is a bikeshedding exercise too. We
> really need that lib because people have started growing their own
> facilities in tools/ and outside so having a lib which implements
> generic functionality for interfacing with the kernel right is going to
> save everyone a lot of time and energy.
 
> So kapi it is, I'm gonna convert what we have to it but leave time for
> acme to wake up and smell the coffee ... and the change :-)

I'm ok with having a library that has this mission statement:

"To offers various helper methods to interface with the Linux kernel:
 debugfs, procfs, sysfs handling routines with no policy, just pure,
 obvious helpers to use kernel functionality."

Naming is a bit hard, to keep it small, descriptive, as API can lead
people to think about other kinds of kernel APIs (syscalls?), "fskapi"
to mean "fs based kernel API" would perhaps be more descriptive? A
longer (more descriptive) possibility would be "linux-fskapi".

- Arnaldo

P.S.: "fskapi" also sounds, humm, fun ;-)
