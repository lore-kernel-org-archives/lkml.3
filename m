Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaL2DiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 22:38:17 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36496 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaL2DiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 22:38:16 -0500
Date: Sun, 28 Dec 2014 19:38:07 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Joe Perches <joe@perches.com>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Kuleshov <kuleshovmail@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: overlayfs: Fix coding style issues, missing a blank
 line after declarations
In-Reply-To: <1419822060.18886.1.camel@perches.com>
Message-ID: <alpine.LSU.2.11.1412281912360.1328@eggly.anvils>
References: <1419746213-5405-1-git-send-email-kuleshovmail@gmail.com> <20141229023939.GL22149@ZenIV.linux.org.uk> <20141229024951.GA9934@ZenIV.linux.org.uk> <1419822060.18886.1.camel@perches.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2014, Joe Perches wrote:
> On Mon, 2014-12-29 at 02:49 +0000, Al Viro wrote:
> > On Mon, Dec 29, 2014 at 02:39:39AM +0000, Al Viro wrote:
> > > On Sun, Dec 28, 2014 at 11:56:53AM +0600, Alexander Kuleshov wrote:
> > > > Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> > > > ---
> > > 
> > > For the record: anything of that sort against fs/*.c will be flushed down
> > > the toilet where such valuable contributions belong.  Don't even bother.
> > 
> > Joe, could you please explain what has driven you to include that into
> > scripts/checkpatch.pl and open the countless sphincters?  Aren't we
> > getting enough pointless patches as it is?
> 
> I don't care for that style actually.
> It was Andrew Morton that wanted it used globally.
> 
> I wanted it to be a --strict test and only for
> net/ and drivers/net/ where David Miller prefers
> that style.
> 
> https://lkml.org/lkml/2014/3/6/550

Although I am guilty of inflicting it on others, just so their patches
keep checkpatch.pl quiet, I have been finding this rule very counter-
productive, and often at odds with long-established good practice.

It makes sense at the head of a substantial function declaring a
collection of variables; but Alexander's patch gives many fine examples
of where it is stupid, and thank you to him for showing it up so well.

In a wrapper function which finds it convenient to declare and assign
a variable before doing a line or two and returning, a common pattern,
a blank line is just distracting hot air to pacify checkpatch.pl.

In a block which needs one extra local variable to do its work, I find
the rule pushes me to move that declaration to the head of the function
instead of keeping it local to the block, just to avoid the unnecessary
blank line.

Please rescind or refine the rule - thanks.

Hugh
