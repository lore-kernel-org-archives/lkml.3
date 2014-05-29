Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaE2TFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:05:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57961 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbaE2TFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:05:12 -0400
Date: Thu, 29 May 2014 21:04:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: David Hagood <david.hagood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug? Older 32 bit program (CivCTP) no longer works under 64
 bit kernel
Message-ID: <20140529190455.GC18230@amd.pavel.ucw.cz>
References: <537568B5.9060208@gmail.com>
 <20140516033632.GA30098@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516033632.GA30098@milliways>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-05-16 04:36:32, Ken Moffat wrote:
> On Thu, May 15, 2014 at 08:24:05PM -0500, David Hagood wrote:
> > I have an old native Linux 32 bit copy of Civilization: Call to Power. It
> > used to work under a 64 bit environment back in the 3.0.x days. However,
> > under recent versions (>3.5) it no longer runs - it complains that it cannot
> > find certain files in the directory. The exact same code will run just fine
> > under a 32 bit version of 3.11. I have a Pentium II as well as the Core 2
> > Duo, both running Ubuntu 14.04, same version of the kernel other than one is
> > 32 bit and one is 64 bit. I've copied the files over from the 32 bit
> > machine, where it runs, to the 64 bit machine, where it does not. I've even
> > gone so far as to copy all the system 32 bit libraries into the CivCTP
> > directory, and forced the program to use them (including using the
> > ld-linux.so loader from that directory) - so in theory it's all the same
> > user space libraries running - the only difference that I can see is that
> > one kernel is 64 bit and one is 32 bit.
> > 
> > Running strace on the program shows that the directories being searched for
> > game assets are corrupted:
> > 
> > 16218 stat64("/home/wowbaggr/CivCTP/ctdata/englisish/uidata/keymap.txt",
> > <unfinished ...>
> > 
> > Note the "englisish" rather than "english".
> > 
> > I'm looking for any suggestions on where to look for what might cause such
> > an issue - what can I do to start tracking this down.
> 
>  I've no ideas about what part of the kernel is causing this, so
> I'll just offer you some thoughts on how to track it down.  At a
> guess, you will have to run 'git bisect' to nail which change broke
> this (or alternatively which change exposed a latent problem).
> 
>  Bisection is fairly well covered on google, for example it finds
> http://landley.net/writing/git-bisect-howto.html
> 
>  The corrupt filename looks (to me, with no experience) like
> something which might be in the filesystem area.  It probably isn't,
> but I don't recall anything at all like this, so I'd better ask - are
> you using an uncommon filesystem for this data ?  This looks like
> such a grievous fault that I would expect someone to have noticed it
> between 3.5.0 and now.
> 
>  And, have you tried any recent kernels (e.g. 3.14.4) to confirm
> that the problem still exists ?  If it turns out that somebody
> already fixed it, that would save you a lot of effort.

And you can probably limit bisection to stat() compat code...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
