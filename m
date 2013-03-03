Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3CCMCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:02:25 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:18986 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3CCMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:02:24 -0500
Date: Sun, 3 Mar 2013 13:02:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, arnd@arndb.de,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
Message-ID: <20130303120221.GA32000@merkur.ravnborg.org>
References: <201211251802.BEJ43247.SHFOJOFVQLFtOM@I-love.SAKURA.ne.jp> <201211192202.IBE48444.VHFLtOSOQFOMJF@I-love.SAKURA.ne.jp> <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp> <24020.1353323415@warthog.procyon.org.uk> <26846.1353334165@warthog.procyon.org.uk> <201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp> <26876.1354110914@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26876.1354110914@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 01:55:14PM +0000, David Howells wrote:
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
> > Tetsuo Handa wrote:
> > > Linux 3.6 builds fine. I can't use "git bisect" until Linux 3.7-rc6 but
> > > possibly caused by either commit 10b63956 "UAPI: Plumb the UAPI Kbuilds
> > > into the user header installation and checking" or commit 40f1d4c2 "UAPI:
> > > Remove the objhdr-y export list".
> > 
> > Bisected to commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into the user header
> > installation and checking".
> 
> Indeed, but that doesn't help much.  The problem is that make's behaviour has
> apparently changed.  I could do with Sam Ravnborg's help to work around this
> since I think he's mainly responsible for the Makefile infrastructure.

Mical is the kbuild person these days.
Anyway - it this still relevant?

I took a quick look and my suspect is the use of $(or ..),
as this feature was added recently to make.

	Sam
