Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbbA2B3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:29:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbA2B3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:29:07 -0500
Date: Wed, 28 Jan 2015 22:52:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: josh@joshtriplett.org
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] drivers/char: Support compiling out /dev/zero
Message-ID: <20150128215225.GA28208@amd>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
 <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
 <20150128210751.GA14006@amd>
 <20150128215106.GA6338@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128215106.GA6338@cloud>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-28 13:51:06, josh@joshtriplett.org wrote:
> On Wed, Jan 28, 2015 at 10:07:51PM +0100, Pavel Machek wrote:
> > On Fri 2015-01-23 12:37:11, Tom Zanussi wrote:
> > > Some embedded systems with tightly controlled userspace have no use
> > > for /dev/zero, and could benefit from the size savings gained by
> > > omitting it.  Add a new EMBEDDED config option to disable it.
> > > 
> > > bloat-o-meter (based on tinyconfig):
> > > 
> > > add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-391 (-391)
> > > function                                     old     new   delta
> > > chr_dev_init                                 162     147     -15
> > > mmap_zero                                     16       -     -16
> > > zero_fops                                    116       -    -116
> > > zero_bdi                                     244       -    -244
> > > 
> > > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > 
> > I'm not sure that 400 bytes are worth additional Kconfig noise. .. and
> > pretty much everyone needs /dev/zero...
> 
> Relatively few, actually, given MMAP_ANONYMOUS.  Memory isn't allocated
> via an mmap of /dev/zero.  It's useful for systems with shells that want
> to redirect from it or read from it, but less useful for environments
> with entirely compiled code.
> 
> /dev/null is much more commonly needed, though there are still systems
> that won't need it (and can just disable read/writes on an fd entirely
> rather than duping /dev/null to that fd).
> 
> That said, I'd be entirely in favor of consolidating many of these
> "miscellaneous character device" options into a couple of Kconfig
> options.  It doesn't seem critical to *individually* control each of
> these files in /dev.

Yes, grouping it would make it more acceptable.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
