Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaBTRCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:02:20 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:46735 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaBTRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:02:17 -0500
Date: Thu, 20 Feb 2014 18:02:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Modra <amodra@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        Cary Coutant <ccoutant@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC] kbuild: drop use of "ld -r" for intermediate links of
 vmlinux
Message-ID: <20140220170209.GA5103@ravnborg.org>
References: <20140216203724.GA19216@ravnborg.org>
 <20140218145856.GZ3386@bubble.grove.modra.org>
 <20140218214801.GA25163@ravnborg.org>
 <20140219010100.GA3386@bubble.grove.modra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219010100.GA3386@bubble.grove.modra.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:31:00AM +1030, Alan Modra wrote:
> On Tue, Feb 18, 2014 at 10:48:01PM +0100, Sam Ravnborg wrote:
> > > Another possibility is to use thin archives to package up the objects.
> > > Thin archives are like normal archives except they just contain paths
> > > to the objects, not the object contents.  Paths are flattened when
> > > adding one thin archive to another.  I think Stephen may have tried
> > > that idea too.
> > I just coded this in a similar simple fashion.
> > It broke building vdso - needs to look into that and will get back when I may
> > understand why my link suddenly broke.
> 
> Missing --whole-archive?

No - at least something else to begin with.
A special liker script is used when building the vdsp files for x86 - and the
linker script is ignored as such when embedded in a .o file with ar it seems.
This is not a big suprise.

The makefile magic used for the vdso part of the kernel needs a bit more coffee
than what is good for me for now...
Will look at it again later.

Thanks for the feedback.

	Sam
