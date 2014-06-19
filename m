Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaFSJ1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbaFSJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:27:02 -0400
Date: Thu, 19 Jun 2014 11:26:48 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Daniel Phillips <daniel@phunq.net>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
In-Reply-To: <20140619082129.GA4309@xo-6d-61-c0.localdomain>
Message-ID: <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
References: <5376B273.7000800@partner.samsung.com> <20140518235555.GC18954@dastard> <537AA802.408@phunq.net> <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz> <02d3b094-808c-4b17-903d-1280d451704b@phunq.net> <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net> <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com> <20140619082129.GA4309@xo-6d-61-c0.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Pavel Machek wrote:

> Date: Thu, 19 Jun 2014 10:21:29 +0200
> From: Pavel Machek <pavel@ucw.cz>
> To: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Daniel Phillips <daniel@phunq.net>, Dave Chinner <david@fromorbit.com>,
>     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     Linus Torvalds <torvalds@linux-foundation.org>,
>     Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [RFC] Tux3 for review
> 
> On Mon 2014-06-16 08:25:54, James Bottomley wrote:
> > On Sun, 2014-06-15 at 14:41 -0700, Daniel Phillips wrote:
> > > On Friday, June 13, 2014 1:20:39 PM PDT, Pavel Machek wrote:
> > > > On Fri 2014-06-13 10:49:39, Daniel Phillips wrote:
> > >  to sign up for a ridiculous amount of largely thankless, but 
> > > perhaps fascinating work. Any volunteers?
> > 
> > The whole suggestion is a non starter: we can't stage core API changes.
> > Even if we worked out how to do that, the staging trees mostly don't get
> > the type of in-depth expert review that you need anyway.
> 
> Well.. most filesystems do not need any core API changes, right?
> 
> > The Cardinal concern has always been the viability page forking and its
> > impact on writeback  ... and since writeback is our most difficult an
> > performance sensitive area, the bar to changing it is high.
> 
> And in this particular case, Daniel was flamed for poor coding style, not
> for page forking. So staging/ would actually help him -- he could concentrate
> on core changes without being distracted by unimportant stuff.

Flamed ? really ? Dave pointed out some serious coding style problems.
Those should be very easy to fix.

Let me remind you some more important problems Dave brought up,
including page forking:

"
 The hacks around VFS and MM functionality need to have demonstrated
 methods for being removed. We're not going to merge that page
 forking stuff (like you were told at LSF 2013 more than a year ago:
 http://lwn.net/Articles/548091/) without rigorous design review and
 a demonstration of the solutions to all the hard corner cases it
 has. The current code doesn't solve them (e.g. direct IO doesn't
 work in tux3), and there's no clear patch set we can review that
 demonstrates how it is all supposed to work. i.e. you need to
 separate out all the page forking code into a separate patchset for
 review, independent of the tux3 code and applies to the core mm/
 code.
"

"
 Then there's all the writeback hacks. You've simply copy-n-pasted
 most of fs-writeback.c, including duplicating structures like struct
 wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
 able to access core structures from kernel module context
 (tux3_setup_writeback(), I'm looking at you). This is completely
 unacceptible for a merge. Again, you need to separate out all the
 writeback changes you need into an independent patchset so that they
 can be reviewed independently of the tux3 code that uses it.
"

-Lukas



> 
> > When you presented page forking at LSF/MM in 2013, it didn't even stand
> > up to basic scrutiny before people found unresolved problems:
> > 
> > http://lwn.net/Articles/548091/
> > 
> > After lots of prodding, you finally coughed up a patch for discussion:
> > 
> > http://thread.gmane.org/gmane.linux.file-systems/85619
> > 
> > But then that petered out again.  I can't emphasise enough that
> > iterating these threads to a conclusion and reposting interface
> > suggestions is the way to proceed on this ... as far as I can tell from
> > the discussion, the reviewers were making helpful suggestions, even if
> > they didn't like the original interface you proposed.
> 
> This obviously needs to be solved, first...
> 									Pavel
> 
