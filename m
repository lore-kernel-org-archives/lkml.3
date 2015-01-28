Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbbA1Ulj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:41:39 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60818 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761301AbbA1Ulh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:37 -0500
Date: Wed, 28 Jan 2015 17:29:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150128172927.GU26493@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <20150128005032.GK28663@atomide.com>
 <201501281458.22088@pali>
 <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
 <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
 <20150128161316.GS26493@n2100.arm.linux.org.uk>
 <20150128161913.GU1569@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128161913.GU1569@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 04:19:13PM +0000, Will Deacon wrote:
> On Wed, Jan 28, 2015 at 04:13:17PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Jan 28, 2015 at 09:57:18AM -0600, Rob Herring wrote:
> > > I'm fine with that, but we just need to have a standard kernel
> > > userspace interface in addition to something like
> > > /proc/device-tree/bootreason. Perhaps this can be the default
> > > implementation for the watchdog dev. Someday when we decide DT is crap
> > > and have a new boot interface, we'll have people relying on
> > > /proc/device-tree. I hope to be retired when that happens...
> > 
> > Anyone who thinks that DT can be replaced in the same way that we made
> > the mistake with ATAGs would really need their head examined.
> > 
> > As you point out, removing DT removes the /proc/device-tree/ sub-tree.
> > Whether we like it or not, that is a userspace API, one which we have
> > users of already.  That pretty much means that we can't remove DT for
> > existing platforms or any platform we have now converted to DT.
> 
> <ok, I'll go there!>
> 
> ... and for platforms that can also be booted via ACPI? If we have to
> convert the ACPI tables into a device-tree purely for /proc/device-tree,
> then we may as well boot with the thing too :)
> 
> Seriously though, I don't see how we can maintain this directory for
> ACPI, regardless of whether or not it's ABI.

And if it needs stating more clearly, you have just shown why adding
a boot reason to devicetree is the wrong thing to do.

Let's say that we do decide to convert the boot reason atag to a device
tree property.  As soon as we do that, it appears in the /proc/device-tree
sub-tree, whether we like it or not, because that sub-tree exports
*everything* mentioned in the DT blob.

So, as soon as we put anything into the DT blob, it immediately becomes
part of the kernel's userspace API, whether we like it or not.  That
means it becomes available for userspace to start (ab)using - again,
whether or not we provide a saner firmware independent interface.

The more we mess around converting crap from one firmware interface to
another, the more problems we're creating for ourselves.  We really
need to re-think our approach to this, and stop this religous "DT is
everything, we must convert everything to DT."

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
