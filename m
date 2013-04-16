Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529Ab3DPTYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:24:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:40189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3DPTYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:24:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,487,1363158000"; 
   d="scan'208";a="295844201"
Date: Tue, 16 Apr 2013 21:23:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the mfd tree with the v4l-dvb tree
Message-ID: <20130416192359.GN8798@zurbaran>
References: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
 <20130410064253.GA4874@zurbaran>
 <20130410064828.6c946ad8@redhat.com>
 <20130416135137.GA31283@zurbaran>
 <CAHQ1cqEAQDRV4st4P+3NzVTiSDXW2+JwYE4DJOEHwyzyDGTwiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqEAQDRV4st4P+3NzVTiSDXW2+JwYE4DJOEHwyzyDGTwiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:25:45AM -0700, Andrey Smirnov wrote:
> On Tue, Apr 16, 2013 at 6:51 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Mauro,
> >
> > On Wed, Apr 10, 2013 at 06:48:28AM -0300, Mauro Carvalho Chehab wrote:
> >> Em Wed, 10 Apr 2013 08:42:53 +0200
> >> Samuel Ortiz <sameo@linux.intel.com> escreveu:
> >>
> >> > Hi Stephen,
> >> >
> >> > On Wed, Apr 10, 2013 at 01:48:13PM +1000, Stephen Rothwell wrote:
> >> > > Hi Samuel,
> >> > >
> >> > > Today's linux-next merge of the mfd tree got a conflict in
> >> > > drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
> >> > > files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
> >> > > commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
> >> > > mfd tree.
> >> > I'm surprised the v4l-dvb tree is carrying this patchset because I haven't
> >> > ACKed it.
> >>
> >> Sorry. Not sure why I understood that you gave your ack. Perhaps I miss-read
> >> one of the comments of that thread.
> > I haven't heard back from Andrey yet. If I don't get anything from him on
> > Wednesday, would you mind reverting this patchset ? I have not ACKed it
> > because it breaks bisectability, and it conflicts with mfd-next.
> >
> > Andrey, any plans to adress my comments from last week ?
> 
> I have a new version of a patchset that addresses your comments and
> incorporates a couple of other patches with bugfixes. Unfortunately I
> haven't had a chance to run it on the test HW I have. I'll try to do
> and post the patches this week, but I am not sure if I'll have time to
> do it before Wednesday.
Linus will most likely tag 3.9 on Sunday or so, I won't take any patches after
that (And probably no patches after Friday...)

 
> As far as I understand all the MFD patches will go through the "mfd"
> tree which doesn't have any version of the SI476X related patches and
> I don't have to worry about making incremental patches. This, however,
> is not the case for "media_tree" this patch here
> http://git.linuxtv.org/media_tree.git/commit/30bac9110455402fa8888740c6819dd3daa2666f
> would be affected and I think that making the need changes
> incrementally as a separate patch would break the bisectability also.
> Right now what I have is a new version of said patch produced by
> editing the history(rebase and squash). Would that work for you,
> Mauro, or do you want an incremental patch on top of the original one?
If you manage to send the patches on time, here is what I propose: I create a
stable branch with all your mfd patches and merge it on my master branch.
Mauro can then also merge it and then apply the rest of your patchset (which
is all v4l and media related, iirc). Before doing so, Mauro would have to
revert the last patchset from you, that's currently sitting in his tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
