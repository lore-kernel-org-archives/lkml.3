Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaLRNZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:25:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaLRNZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:25:01 -0500
Date: Thu, 18 Dec 2014 21:25:05 +0800
From: Fam Zheng <famz@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: patch tracking tools (was Re: Maintainer abuse)
Message-ID: <20141218132505.GB21344@fam-t430.nay.redhat.com>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
 <20141212234336.GA28451@pd.tnic>
 <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
 <5492A8F0.9030107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5492A8F0.9030107@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12/18 11:14, Paolo Bonzini wrote:
> 
> 
> On 13/12/2014 14:52, One Thousand Gnomes wrote:
> > Is it the year for a Google summer of code project or similar to turn
> > patchwork into a proper patch management tool (one that collects the
> > patches, provides a good maintainer interface, tells people automatically
> > that their patches are queued, deletes repeats, gives them status urls
> > they can give to managers or check, and also has the right bits
> > maintainer side to actually do stuff like send out "your patch set no
> > longer merges, please update" emails, and tell the maintainer if it
> > merges, the coding style important bits, etc and with buttons for "merge
> > me"
> 
> People from the QEMU project are working on something like this.
> 
> Right now the only public tool is "patches", which is a) a server that
> gathers patch series and Reviewed-bys, and detects when they are
> applied; b) a tool to query the list and also apply patches/pull
> requests; c) a notmuch plugin that lets you query the list from Emacs.
> The tool is pretty simple; the server produces a simple JSON file with
> the patches from the last 30 days, the client tools download it and
> operate on a local copy.
> 
> These tools are at https://github.com/stefanha/patches.  A sample
> database is at http://wiki.qemu.org/patches/patches.json (you can play
> with it: "patches fetch http://wiki.qemu.org/patches/patches.json").
> 
> If you want to see how a server is set up, see
> https://github.com/stefanha/qemu-patches.
> 
> Also, we've added a "--message-id" to "git am" in order to help the
> "patches" server detect what was applied.  The client tool already did
> that when applying patches, but the next version of git will let
> submaintainers contribute to the tracking even if they prefer "git am"
> to "patches apply".
> 
> The "patches" tool is operated mostly from the command line.  There is
> also a new tool in the works which scans the mailing list, applies what
> it founds, checks it with checkpatch.pl, and compiles them.  It uses
> Docker to quickly set up a compilation environment (and of course for
> buzzword compliancy).  It also has a web interface that lets you do
> simple searches.
> 
> This is more experimental and does not yet have a public instance
> (source is at https://github.com/famz/patchew).

FWIW, I've just setup an server instance today on a public available VM, which
is starting to subscribe to qemu-devel@nongnu.org and testing the patches:

http://209.132.179.37/

This tool wants to do two things to aid maintainers/reviewers:

1) Reply and complain if coding style violation / broken building / "make check"
failure is seen.

2) Provide an easy to use web interface to query patches.

> 
> One thing that makes automation a bit easier for QEMU is that it does
> not have a merge window; while we do have a central committer that takes
> pull requests, the phases are a bit more traditional (2 month
> development, 2 weeks preparation for freeze, 1 month feature freeze).
> For Linux it would be more important for the tool to know which patches
> are for which tree, possibly based on the destination mailing lists.

Things can be complicated, for example patch series dependencies.  It's a
question to think about whether we need it to be complete or want to keep it
simple.

I think such as a tool has to start as an auxiliary before becoming part of the
process.

Fam
