Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbbA2CAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:00:08 -0500
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:33622 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbbA2CAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:00:03 -0500
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 21:00:02 EST
Date: Wed, 28 Jan 2015 13:51:06 -0800
From: josh@joshtriplett.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] drivers/char: Support compiling out /dev/zero
Message-ID: <20150128215106.GA6338@cloud>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
 <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
 <20150128210751.GA14006@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128210751.GA14006@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:07:51PM +0100, Pavel Machek wrote:
> On Fri 2015-01-23 12:37:11, Tom Zanussi wrote:
> > Some embedded systems with tightly controlled userspace have no use
> > for /dev/zero, and could benefit from the size savings gained by
> > omitting it.  Add a new EMBEDDED config option to disable it.
> > 
> > bloat-o-meter (based on tinyconfig):
> > 
> > add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-391 (-391)
> > function                                     old     new   delta
> > chr_dev_init                                 162     147     -15
> > mmap_zero                                     16       -     -16
> > zero_fops                                    116       -    -116
> > zero_bdi                                     244       -    -244
> > 
> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> 
> I'm not sure that 400 bytes are worth additional Kconfig noise. .. and
> pretty much everyone needs /dev/zero...

Relatively few, actually, given MMAP_ANONYMOUS.  Memory isn't allocated
via an mmap of /dev/zero.  It's useful for systems with shells that want
to redirect from it or read from it, but less useful for environments
with entirely compiled code.

/dev/null is much more commonly needed, though there are still systems
that won't need it (and can just disable read/writes on an fd entirely
rather than duping /dev/null to that fd).

That said, I'd be entirely in favor of consolidating many of these
"miscellaneous character device" options into a couple of Kconfig
options.  It doesn't seem critical to *individually* control each of
these files in /dev.

Personally, I'm hoping that we eventually end up with a disableable
CONFIG_CHAR similar to CONFIG_BLOCK.

- Josh Triplett
