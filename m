Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaJNBxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:53:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaJNBxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:53:36 -0400
Date: Tue, 14 Oct 2014 03:52:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable
 length encoding.
Message-ID: <20141014015233.GA24799@kroah.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
 <1412888588-26755-164-git-send-email-kamal@canonical.com>
 <20141010053048.GD3594@1wt.eu>
 <1413221463.11421.30.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413221463.11421.30.camel@fourier>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 10:31:03AM -0700, Kamal Mostafa wrote:
> On Fri, 2014-10-10 at 07:30 +0200, Willy Tarreau wrote:
> > Hi Kamal,
> > 
> > [ removed Don Bailey from the CC who's certainly not interested in this ]
> > 
> > On Thu, Oct 09, 2014 at 02:03:08PM -0700, Kamal Mostafa wrote:
> > > 3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Willy Tarreau <w@1wt.eu>
> > > 
> > > commit 72cf90124e87d975d0b2114d930808c58b4c05e4 upstream.
> > 
> > (...)
> 
> Hi Willy-
> 
> Thanks very much for reviewing this.
> 
> > This one (and the accompanying revert) are still not present in more
> > recent stable kernels, so I find it surprizing that you're proposing
> > to integrate them now.
> 
> I can hold out those lzo fixes until the next 3.13-stable if you prefer.

Please do so.

> But fwiw...
> 
> >  If someone upgrades from 3.13.11.9 to 3.14.21
> > or 3.16.5, they'd expect to keep all fixes but will lose this one, so
> > this is a bit confusing.
> 
> I think those sorts of scheduling mismatches and discrepancies between
> stable versions are pretty common.  Examples:  The top 11 commits in
> v3.12.30 have not yet been applied[0] to any of the newer stable
> branches;

Those -mm patches from Mel are "special", I'm taking it slow in merging
them, doing lots of local testing and code review, and not all of them
even are relevant for 3.14, so don't take the acceptance /
non-acceptance of them as any kind of "proof" of anything at all.

> Many of the commits in v3.10.57 have not yet been applied[1]
> to linux-3.12.y but have been released in other newer stables.

That's because I am ahead of Jiri, which will almost always happen due
to our different workflows and time available to spend on stable
kernels.

> >  Is there any reason you're not tracking fixes
> > from more recent versions like Jiri, Li, Ben and I are doing ?
> 
> We (the Canonical stable maintainers) have always tracked the "cc:
> stable" fixes directly from mainline, not from the more-recent-version
> branches.  Given the examples above, it seems that the kernel.org
> maintainers are doing that too, yes?

You have included patches in your release that are not in _any_ public
release on kernel.org yet.  Which is fine, you are allowed to do
whatever you want, but that goes against the existing rules of stable
patches that we have been following for well over the past year for when
it is acceptable to add a patch to a stable release.

Yet another reason I _strongly_ urge you to mark your kernels with some
type of "name" to help reduce the confusion of others that your kernels
might be somehow associated with kernel.org releases.

greg k-h
