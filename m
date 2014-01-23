Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaAWPFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:05:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbaAWPFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:05:03 -0500
Date: Thu, 23 Jan 2014 16:05:01 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: fanotify use after free.
Message-ID: <20140123150501.GC28796@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <20140123003240.GA25547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123003240.GA25547@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-01-14 19:32:40, Dave Jones wrote:
> On Wed, Jan 22, 2014 at 04:08:52PM -0800, Linus Torvalds wrote:
>  > On Wed, Jan 22, 2014 at 3:36 PM, Jan Kara <jack@suse.cz> wrote:
>  > >
>  > > But refcounting seems like an overkill for this - there is exactly one
>  > > fanotify_response_event structure iff it is a permission event. So
>  > > something like the (completely untested) attached patch should fix the
>  > > problem. But I agree it's a bit ugly so we might want something different.
>  > > I'll try to think about something better tomorrow.
>  > 
>  > Ok, In the meantime, Dave, can you verify whether this hacky patch
>  > fixes your problem?
> 
> It actually seems worse. I see the tail end of what looks like a slab corruption
> trace, and then a total lockup.  And of course none of this makes it over ttyUSB0
> because it happens so early. Grr.
  Drat. Since this seems reasonably reproducible, I'll try to reproduce
and debug this (it seems systemd is using fanotify in a way that triggers
this). Thanks for testing.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
