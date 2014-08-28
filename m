Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936248AbaH1DqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:46:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbaH1DqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:46:16 -0400
Date: Thu, 28 Aug 2014 05:46:13 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH] coccinelle: add pycocci wrapper for
	multithreaded support
Message-ID: <20140828034613.GD3347@wotan.suse.de>
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> <1397152289.4757.28.camel@jlt4.sipsolutions.net> <20140410175748.GK14815@wotan.suse.de> <alpine.DEB.2.02.1404102131390.2201@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404102131390.2201@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:32:34PM +0200, Julia Lawall wrote:
> 
> 
> On Thu, 10 Apr 2014, Luis R. Rodriguez wrote:
> 
> > On Thu, Apr 10, 2014 at 07:51:29PM +0200, Johannes Berg wrote:
> > > On Thu, 2014-04-10 at 10:48 -0700, Luis R. Rodriguez wrote:
> > > 
> > > > You just pass it a cocci file, a target dir, and in git environments
> > > > you always want --in-place enabled. Experiments and profiling random
> > > > cocci files with the Linux kernel show that using just using number of
> > > > CPUs doesn't scale well given that lots of buckets of files don't require
> > > > work, as such this uses 10 * number of CPUs for its number of threads.
> > > > For work that define more general ruler 3 * number of CPUs works better,
> > > > but for smaller cocci files 3 * number of CPUs performs best right now.
> > > > To experiment more with what's going on with the multithreading one can enable
> > > > htop while kicking off a cocci task on the kernel, we want to keep
> > > > these CPUs busy as much as possible. 
> > > 
> > > That's not really a good benchmark, you want to actually check how
> > > quickly it finishes ... If you have some IO issues then just keeping the
> > > CPUs busy trying to do IO won't help at all.
> > 
> > I checked the profile results, the reason the jobs finish is some threads
> > had no work or little work. Hence why I increased the number of threads,
> > depending on the context (long or short cocci expected, in backports
> > at least, the long being all cocci files in one, the short being --test-cocci
> > flag to gentree.py). This wrapper uses the short assumption with 10 * num_cpus
> > 
> > > > Since its just a helper I toss it into the python directory but don't
> > > > install it. Hope is that we can evolve it there instead of carrying this
> > > > helper within backports.
> > > 
> > > If there's a plan to make coccinelle itself multi-threaded, what's the
> > > point?
> > 
> > To be clear, Coccinelle *has* a form of multithreaded support but requires manual
> > spawning of jobs with references to the max count and also the number thread
> > that this new process you are spawning belongs to. There's plans to consider
> > reworking things to handle all this internally but as I discussed with Julia
> > the changes required would require some structural changes, and as such we
> > need to live with this for a bit longer. I need to use Coccinelle daily now,
> > so figured I'd punt this out there in case others might make use of it.
> 
> I agree with Luis.  Multithreading inside Coccinelle is currently a 
> priority task, but not a highest priority one.

Folks, anyone object to merging pycocci in the meantime? I keep using it outside
of backports and it does what I think most kernel developers expect. This would
be until we get proper parallelism support in place.

  Luis
