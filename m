Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaF2UfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:35:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33754 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaF2UfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:35:06 -0400
Date: Sun, 29 Jun 2014 22:35:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] vt: disable console blanking by default
Message-ID: <20140629203504.GA11829@amd.pavel.ucw.cz>
References: <20140618092730.GD22226@mother.pipebreaker.pl>
 <20140622163728.GA4461@amd.pavel.ucw.cz>
 <20140625114109.GD18532@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625114109.GD18532@mother.pipebreaker.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-25 13:41:09, Tomasz Torcz wrote:
> On Sun, Jun 22, 2014 at 06:37:29PM +0200, Pavel Machek wrote:
> > On Wed 2014-06-18 11:27:31, Tomasz Torcz wrote:
> > > 
> > > >From ea7cf47e3230eda63aa6c46092719437f9bbae8e Mon Sep 17 00:00:00 2001
> > > From: Tomasz Torcz <tomek@pipebreaker.pl>
> > > Date: Wed, 18 Jun 2014 11:18:06 +0200
> > > Subject: [PATCH] vt: disable console blanking by default
> > > 
> > >   Remove default 10 minute blank interval. Instead: never blank by
> > >   default.
> > >   "Screensaving" is no longer useful.  Today it only provides
> > >   obstacle when interacting with text console, especially through
> > >   remote lights-out management solutions.
> > > 
> > > Signed-off-by: Tomasz Torcz <tomek@pipebreaker.pl>
> > 
> > Dunno. You'll kill an LCD if you let same image there for too
> > long. Make it 10hours?
> 
>   There is no practical difference between 10 minutes and 10 hours.  Both
> are more than none.  This means that If I need to access console, it
> will probably be blanked.  For some servers, console access is needed
> less than once per year, if ever.  But IF the console need to be accessed,
> there's a strong reason to it (some kind of fault), and having to press
> anything to unblank may be invasive.
> 
>  I would prefer to fix the issue at the source, instead of sticking "consoleblank=0"
> in grub2.cfg on houndreds of boxes.  BTW, kernel already contains "consoleblank=0" in 
> arch/arc/boot/dts/nsimosci.dts and arch/arm/boot/dts/omap3-lilly-a83x.dtsi 
> 
>   Is LCD damage for currently produced LCDs real issue, still?

Probably yes. Plus, people are still running CRTs and blanked screen
still eats significantly less power. So "consoleblank=0" seems right
solution for you, and current default still sounds right.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
