Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaJMStA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:49:00 -0400
Received: from 1wt.eu ([62.212.114.60]:30493 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaJMSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:48:58 -0400
Date: Mon, 13 Oct 2014 20:48:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable length encoding.
Message-ID: <20141013184853.GD30087@1wt.eu>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com> <1412888588-26755-164-git-send-email-kamal@canonical.com> <20141010053048.GD3594@1wt.eu> <1413221463.11421.30.camel@fourier>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413221463.11421.30.camel@fourier>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Mon, Oct 13, 2014 at 10:31:03AM -0700, Kamal Mostafa wrote:
> > This one (and the accompanying revert) are still not present in more
> > recent stable kernels, so I find it surprizing that you're proposing
> > to integrate them now.
> 
> I can hold out those lzo fixes until the next 3.13-stable if you prefer.

It would be better in my opinion.

> But fwiw...
> 
> >  If someone upgrades from 3.13.11.9 to 3.14.21
> > or 3.16.5, they'd expect to keep all fixes but will lose this one, so
> > this is a bit confusing.
> 
> I think those sorts of scheduling mismatches and discrepancies between
> stable versions are pretty common.

I don't think so. In my opinion when this happens it's mostly a mistake.

> Examples:  The top 11 commits in
> v3.12.30 have not yet been applied[0] to any of the newer stable
> branches;

I think this doesn't happen often and probably it's just a matter of
reporting it when it happens so that maintainers double-check on their
side.

> Many of the commits in v3.10.57 have not yet been applied[1]
> to linux-3.12.y but have been released in other newer stables.

In Jiri's defense, he's in the middle of two versions managed by Greg,
so when Greg sends a batch of 3.10+3.14 releases, there is a small
window where 3.12 can be lagging a bit. But I think that this is
different from having patches that are not in the most recent
versions because users are much less likely to upgrade from one of
Greg's maintained kernels to any of ours than the opposite.

> >  Is there any reason you're not tracking fixes
> > from more recent versions like Jiri, Li, Ben and I are doing ?
> 
> We (the Canonical stable maintainers) have always tracked the "cc:
> stable" fixes directly from mainline, not from the more-recent-version
> branches.  Given the examples above, it seems that the kernel.org
> maintainers are doing that too, yes?

Possible, I don't know for others though I know that Greg tends to
be picky about mistakes like this not to happen too often, so I
suspect there's a bit of care there. I'm personally in a special
situation considering that I'm on the tail so the amount of changes
to apply to certain patches to backport them suggests that I more
often pick them from 3.2 or 3.4 than mainline (except for the ones
that I receive directly).

I can't speak for Greg but I think that sometimes if you notice that
you're merging a patch which is missing in most recent -stable branches,
it would be nice to send a reminder about it, as it's certainly possible
that one slips through from time to time.
 
Thanks,
Willy

