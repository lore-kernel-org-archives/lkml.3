Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaAWXzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 18:55:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaAWXzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 18:55:51 -0500
Date: Fri, 24 Jan 2014 00:55:49 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140123235549.GA7363@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-01-14 16:07:45, Jiri Kosina wrote:
> On Thu, 23 Jan 2014, Jan Kara wrote:
> 
> > > > > But refcounting seems like an overkill for this - there is exactly one
> > > > > fanotify_response_event structure iff it is a permission event. So
> > > > > something like the (completely untested) attached patch should fix the
> > > > > problem. But I agree it's a bit ugly so we might want something different.
> > > > > I'll try to think about something better tomorrow.
> > > > 
> > > > Ok, In the meantime, Dave, can you verify whether this hacky patch
> > > > fixes your problem?
> > > 
> > > I reported the same slab corruption yesterday as well here:
> > > 
> > > 	https://lkml.org/lkml/2014/1/22/173
> > > 
> > > With the patch applied, I am still seeing the slab corruption, preceeded 
> > > by GPF (which is not there without the patch) in 
> > > lockref_put_or_lock(&dentry->d_lockref) in dput():
> >   Hmm, OK. Can you please send me your .config? I'll try to reproduce this
> > myself.
> 
> Attached.
> 
> The userspace is systemd-based.
  Strange. I've installed systemd system (openSUSE 13.1) and it boots with
the latest Linus' kernel just fine (and I have at least FANOTIFY and
SLAB debugging set the same way as you). But it was only a KVM guest. I'll
try tomorrow with a physical machine I guess.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
