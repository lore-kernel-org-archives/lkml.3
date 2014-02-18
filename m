Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBRVsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:48:21 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:44421 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaBRVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:48:18 -0500
Date: Tue, 18 Feb 2014 22:48:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Modra <amodra@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        Cary Coutant <ccoutant@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC] kbuild: drop use of "ld -r" for intermediate links of
 vmlinux
Message-ID: <20140218214801.GA25163@ravnborg.org>
References: <20140216203724.GA19216@ravnborg.org>
 <20140218145856.GZ3386@bubble.grove.modra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218145856.GZ3386@bubble.grove.modra.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:28:56AM +1030, Alan Modra wrote:
> On Sun, Feb 16, 2014 at 09:37:24PM +0100, Sam Ravnborg wrote:
> > The trick used is that for each directory a linker script is
> > generated that name all the file to be linked - and for
> > sub-directories this is just the linker script for that directory.
> > 
> > The file continue to be named "built-in.o" but it is really a linker script.
> 
> You'll need binutils newer than 2012-06-25
> https://sourceware.org/ml/binutils/2012-06/msg00201.html
> 
> > I recall the idea is from someone else - but have long lost memory of
> > from where I saw it.
> 
> I think it might have been my idea originally, implemented by Stephen
> Rothwell.
Sounds right - added in cc:

> 
> Another possibility is to use thin archives to package up the objects.
> Thin archives are like normal archives except they just contain paths
> to the objects, not the object contents.  Paths are flattened when
> adding one thin archive to another.  I think Stephen may have tried
> that idea too.
I just coded this in a similar simple fashion.
It broke building vdso - needs to look into that and will get back when I may
understand why my link suddenly broke.

Thanks for the feedback!

	Sam
