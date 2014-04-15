Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaDOJgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:36:47 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48175 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaDOJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:36:43 -0400
Date: Tue, 15 Apr 2014 11:36:22 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, John Crispin <blogic@openwrt.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140415093622.GB27556@linux-mips.org>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
 <20140409081709.GA283@x4>
 <20140414103205.GA2846@gmail.com>
 <20140415010003.GA2765@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415010003.GA2765@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 06:00:04PM -0700, Josh Triplett wrote:

> > and it slows down 
> > kernel development'.
> 
> No, it doesn't slow down development builds; it makes kernel builds
> slower if and only if LTO is turned on, which most kernel developers
> won't need to do.  On the other hand, distro and embedded kernels can do
> so for final builds, and developers pushing to minimize the kernel can

LTO inherently is going to slow down development because it does inflate
the testing matrix - a developer really should test an LTO build.

That said, the increased checking of the source code for validity across
compilation units done by the LTO final link is a benefit by itself.  With
my MIPS maintainer head on I can say it's required fixes / cleanups of
several thousand lines which have already been merged several kernel
versions ago because they all were beneficial even without LTO.  A mere
three small commits preparing arch/mips for LTO support and that don't
make sense without LTO are remaining.  So it's not a support/testing
nightmare.

And while the code size reduction is less for MIPS than what others have
reported for their platforms (I'm still investigating) is still is enough
that embedded developers would commit murder for.

  Ralf
