Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3GWOvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:51:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab3GWOvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:51:04 -0400
Date: Tue, 23 Jul 2013 16:51:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC -v3 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130723145103.GL8677@dhcp22.suse.cz>
References: <1374493502-31907-1-git-send-email-mhocko@suse.cz>
 <1374503566-2521-1-git-send-email-mhocko@suse.cz>
 <20130723135334.GF126784@redhat.com>
 <20130723140729.GH8677@dhcp22.suse.cz>
 <20130723144408.GH126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723144408.GH126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-07-13 10:44:08, Don Zickus wrote:
> On Tue, Jul 23, 2013 at 04:07:29PM +0200, Michal Hocko wrote:
> > On Tue 23-07-13 09:53:34, Don Zickus wrote:
> > > On Mon, Jul 22, 2013 at 04:32:46PM +0200, Michal Hocko wrote:
> > > > The nmi one is disabled and then reinitialized from scratch. This
> > > > has an unpleasant side effect that the allocation of the new event might
> > > > fail theoretically so the hard lockup detector would be disabled for
> > > > such cpus. On the other hand such a memory allocation failure is very
> > > > unlikely because the original event is deallocated right before.
> > > > It would be much nicer if we just changed perf event period but there
> > > > doesn't seem to be any API to do that right now.
> > > > It is also unfortunate that perf_event_alloc uses GFP_KERNEL allocation
> > > > unconditionally so we cannot use on_each_cpu() and do the same thing
> > > > from the per-cpu context. The update from the current CPU should be
> > > > safe because perf_event_disable removes the event atomically before
> > > > it clears the per-cpu watchdog_ev so it cannot change anything under
> > > > running handler feet.
> > > 
> > > I guess I don't have a problem with this.  I was hoping to have more
> > > shared code with the regular stop/start routines but with the pmu bit
> > > locking (to share pmus with oprofile), you really need to unregister
> > > everything to stop the lockup detector.  This makes it a little too heavy
> > > for a restart routine like this.
> > 
> > I am not sure I understand the above. Regular stop/start is about all
> > the machinery, I have tried to reduce the restarting to bare minimum.
> > Do you find the current version heavier than the full disable_all &&
> > enable_all?
> 
> No, I find your restart mechanism lighter than full disable_all.  I would
> love to have the lockup detector just disable itself on stop and re-enable
> on start.  But because of oprofile, the lockup has to free up its event
> on stop and recreate it on start, which kinda sucks.
> 
> Anyway it was just an aside.

Ohh, I see.
 
> > > The only odd thing is I can't figure out which version you were using to
> > > apply this patch.  I can't find old_thresh (though I understand the idea
> > > of it).
> > 
> > current Linus tree (linux-next - 20130723 - has it as well AFAICS)
> 
> Ok. Thanks.  Ah, I see.  I forgot Frederic modified pieces there.  The
> threading keeps changing.  I see why you took your approach.
> 
> Should be fine.
> 
> Acked-by: Don Zickus <dzickus@redhat.com>

Thanks! I will repost this without RFC if nobody else objects.

-- 
Michal Hocko
SUSE Labs
