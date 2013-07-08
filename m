Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3GHH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:28:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:8412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3GHH2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:28:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1018,1363158000"; 
   d="scan'208";a="361859511"
Date: Mon, 8 Jul 2013 15:28:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Jim Garlick <garlick@llnl.gov>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v9fs:for-linus 7/7] ERROR: code indent should use tabs where
 possible
Message-ID: <20130708072812.GC28294@localhost>
References: <51d9c6c4.k6qhnvy45dNR8Ghq%fengguang.wu@intel.com>
 <20130708004233.GA8958@localhost>
 <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
 <20130708033004.GA20091@localhost>
 <1373255644.1893.3.camel@joe-AO722>
 <20130708044542.GE20091@localhost>
 <1373259267.1893.7.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373259267.1893.7.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, Jul 07, 2013 at 09:54:27PM -0700, Joe Perches wrote:
> On Mon, 2013-07-08 at 12:45 +0800, Fengguang Wu wrote:
> > On Sun, Jul 07, 2013 at 08:54:04PM -0700, Joe Perches wrote:
> > > On Mon, 2013-07-08 at 11:30 +0800, Fengguang Wu wrote:
> > > > In long run I'd like to disable
> > > > the check types that tend to have false positives.  As for now, these
> > > > checks are disabled in my checkpatch robot:
> > > 
> > > Are you using a .checkpatch.conf file?
> > 
> > Nope.
> > 
> > > > PATCH_PREFIX
> > > > LONG_LINE
> > > > CAMELCASE
> > > 
> > > That's a --strict test
> > 
> > Yes. The CAMELCASE checks are false positives for the USB subsystem.
> > Where they followed the USB spec and use names like bInterfaceClass
> > all over the places.
> 
> The latest version of checkpatch should avoid this.

That'd be great!  So I'll use the latest version and take the
CAMELCASE check back.

> > > > MISSING_SIGN_OFF
> > > 
> > > Why would you even consider this one?
> > 
> > It produces
> > 
> >         ERROR: Missing Signed-off-by: line(s)
> > 
> > on
> >         commit: 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376 Linux 3.10
> 
> Well, clearly Linus should sign off on his own commits...

Heh.

> >         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git master
> >         commit: 97966e7ec944580bc3f46712f34ecb3c854fdd4b [37/81] Revert "ALSA: hda - Fix wrong power setup for HP paths of VIA codecs"
> > 
> >         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git master
> >         head:   120b1922175789a8a9bdafb7ea755fc63de2f392
> >         commit: 10296279acc5d3caeca7b2cfde329c8280fe67e5 [32/81] Merge branch 'for-linus'
> > 
> > and many other commits
> 
> Not in -next as of today.

Since I test bleeding edge trees and many of them are not formal enough, I'm
afraid I have to ignore the missing Signed-off-by lines..

10071   F Jul 05 Cc fengguang.wu (  37:0) [asoc:topic/ak4554 0/2] ERROR: Missing Signed-off-by: line(s)
10087   F Jul 05 Cc fengguang.wu (  36:0) [sound:master 32/81] ERROR: Missing Signed-off-by: line(s)
10088   F Jul 05 Cc fengguang.wu (  36:0) [sound:master 37/81] ERROR: Missing Signed-off-by: line(s)
10116   F Jul 06 Cc fengguang.wu (  37:0) [x0148406:tmp 0/45] ERROR: Missing Signed-off-by: line(s)
10117   F Jul 06 Cc fengguang.wu (  37:0) [x0148406:tmp 1/45] ERROR: Missing Signed-off-by: line(s)
10118   F Jul 06 Cc fengguang.wu (  37:0) [x0148406:tmp 2/45] ERROR: Missing Signed-off-by: line(s)
10119   F Jul 06 Cc fengguang.wu (  37:0) [x0148406:tmp 3/45] ERROR: Missing Signed-off-by: line(s)
10120   F Jul 06 Cc fengguang.wu (  37:0) [mmc:mmc-next 0/88] ERROR: Missing Signed-off-by: line(s)
10183   F Jul 07 Cc fengguang.wu (  37:0) [target:target-per-cpu-ida 0/58] ERROR: Missing Signed-off-by: line(s)

> > > > TRAILING_STATEMENTS
> > > False positives?  Got an example?
> > tree:   git://git.freedesktop.org/git/nouveau/linux-2.6 drm-nouveau-next
> > head:   d2989b534ef6834ebf2425aecc040b894b567c91
> > commit: 01672ef454307bf63e93defb3599399b678ff58b [3/68] drm/nve0/fifo: copy engine context stored in ramfc, not externally
> > 
> > ERROR: trailing statements should be on next line
> > #28: FILE: drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c:146:
> > +       case NVDEV_ENGINE_GR   : addr = 0x0210; break;
> 
> Not false positives.

Yeah, however it does represent a common practice that I feel like
respecting the developers' own choice.

Thanks,
Fengguang
