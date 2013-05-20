Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3ETLds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:33:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:49903 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab3ETLdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:33:47 -0400
Date: Mon, 20 May 2013 07:33:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ian Stirling <gplvio@mauve.plus.com>
Cc: "luke.leighton" <luke.leighton@gmail.com>, legal@lists.gpl-violations.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
Message-ID: <20130520113337.GB8404@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ian Stirling <gplvio@mauve.plus.com>,
	"luke.leighton" <luke.leighton@gmail.com>,
	legal@lists.gpl-violations.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <51972CAF.3060802@gmail.com>
 <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <ce644e6e12d68aaabed7403b5f21c124@imap.plus.net>
 <CAPweEDztcCOgKQmMSK3R6TMJoOo5m4b5KFg1nVySexqdVZu_DQ@mail.gmail.com>
 <18adac813097459e346581e2d81389be@imap.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18adac813097459e346581e2d81389be@imap.plus.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:24:02AM +0100, Ian Stirling wrote:
> >i wish to know the procedure by which my formally and publicly
> >announced release of all linux kernel contributions under the dual
> >licenses of GPLv2 and GPLv3+ may be entered - formally - upstream and
> >into the linux kernel sources being maintained on git.kernel.org
> 
> Umm - that was my point - though I did not make it explicitly.
> 
> Either there is a policy change, and it is decided to allow such
> dual-licenced code in the repo, or your code does not get checked in,
> as it does not have a compatible licence.

Actually, it's more subtle than that.  As I said earlier, we *do*
allow dual-licensed code in the repo, but it's on a per-file basis.
There is no way to designate that certain lines in a files has a
different copyright license than the lines in the file; I assume
people will understand why that's an accounting nightmare.

The more subtle thing to consider is that with dual-licensed code,
***anyone*** has the ability to strip one of the licenses from the
code in the course of making modification.  So for example, suppose I
released e2fsck/recovery.c under GPLv2+.  I would never do that,
because then someone might make improvements to the e2fsck/recovery.c
under GPLv3-only terms, and then strip the GPLv2 license from the file
and release it under GPLv3-only terms.  That's a completely legal
thing to do; it may not be ethical, and it may not improve that
person's standing in the community, but it's completely legal.  (It's
also identical to what the FSF has done when it has converted GPLv2+
projects to GPLv3-only projects, although it's a more acceptable when
the primary copyright owner of the file does it; what I'm calling out
here is that ***anyone*** can legally take GPLv2/v3 code and turn it
into GPLv2 or GPLv3 only code.)

The reason why I dislike someone taking GPLv2/v3 code and stripping
out the GPLv2 license is because it makes new versions of code which I
had originally written becoming available only under a GPLv3 license.
This would mean that in my example of e2fsck/recovery.c, those
enhacements would not be available for use in the Linux kernel as
fs/ext4/recovery.c.  It's for the same reason why BSD folks get upset
when BSD code gets turned into GPLv2 code --- and the standard retort
to their being upset is "well, you shouldn't have released it under
the BSD license, then, since the BSD license will allow you to do
this".  Applied to this GPLv2/GPLv3 incompatibility issue, and my
extreme dislike of the anti-Tivo clause in GPLv3, this explains why I
choose not to release my code under a GPLv2/GPLv3 dual-license or a
GPLv2+ license.

But there's a flip side to this, which is the same legal argument
***also*** allows a kernel maintainer to take a contribution which is
under a GPLv2/v3 or GPLv2+ license, and incorporate it into a
GPLv2-only file, and not bother to mark that it originally came from a
GPLv2+ or GPLv2/v3 contribution.  The original contribution is still
licensed that way, and if you go through the mailing list archives,
you could find that contribution and extract that code and use it in
some other GPLv3 project.  But we are under no obligation to mark that
a particular set of lines in a file originally came from a GPLv2/v3 or
GPLv2+ contribution.

But a very large number of senior Linux kernel developers (not just
Linus) have stated that we stand against the GPLv3 anti-Tivoization
clause, and so we intend to keep the Linux kernel sources under a
GPLv2-only license.  That's not to say that certain drivers won't be
dual licensed, for specific reasons, but you shouldn't expect that
core kernel files will be GPLv3 compatible in the near future.

     	    	       	  		      - Ted
