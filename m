Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaDOPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:21:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaDOPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:21:50 -0400
Date: Tue, 15 Apr 2014 08:24:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140415152452.GC7311@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
 <20140414191143.GA26864@kroah.com>
 <20140414231254.392c0df8@endymion.delvare>
 <20140415045214.GA32541@kroah.com>
 <CA+5PVA4-8CDT1Mfw_t6WKu6zmo1Ugn4ssTXPCS-W-bPnKtH=5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4-8CDT1Mfw_t6WKu6zmo1Ugn4ssTXPCS-W-bPnKtH=5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 07:50:05AM -0400, Josh Boyer wrote:
> On Tue, Apr 15, 2014 at 12:52 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Apr 14, 2014 at 11:12:54PM +0200, Jean Delvare wrote:
> >> And it's not going to get any better over time. As others have already
> >> mentioned, most new drivers these days are NOT for x86, they are for
> >> ARM, AVR32 and other fancy embedded architectures.
> >>
> >> "Just say m to everything" is just so wrong today that at SUSE we are
> >> very close to switching our policy to "just say no to everything and
> >> wait for people to complain about missing drivers." This may not sound
> >> too appealing but this is the only way to keep the kernel package at a
> >> reasonable size (and build time), as long as upstream doesn't help us
> >> make smarter decisions. Useless modules aren't free, they aren't even
> >> cheap.
> 
> FWIW, we did that policy changed in Fedora a while ago.  Not
> wholesale, but if it looks niche, it's disabled by default and enabled
> only on request.
> 
> > I'd argue that your build systems need to get faster, the laptop I'm
> > typing this on can do a full modconfig build, with over 3000 modules, in
> > around 20 minutes.  My build server in the cloud can do that in less
> > than 5 minutes, and that's not a very fast machine these days.
> 
> Is that literally 'make modconfig && make bzImage && make modules' in
> those setups?

Yes, I use ktest with the allmodconfig option.

> I'm curious if the distros have some options enabled
> that significantly impact build time.  Perhaps CONFIG_DEBUG_INFO or
> something else like that.  Could you send me whatever config results
> from what you're building in 5min?

You can use ktest with the BUILD_TYPE set to allmodconfig and it will
reproduce the same options.

> It takes my desktop machine about 30-45min to build an x86_64 kernel
> RPM with the current configs.  Now granted, that's a bit more than
> just building a kernel in a local git tree, but it's nowhere near
> 5min.  Our official build servers show similar timings for x86_64.
> 
> For ARM kernels, it takes about 3.5-4 hours.  That's due to policy
> decisions on now allowing cross-builds in the distro (sigh), so all of
> the kernels are built on native ARM machines.

That's really crazy to do that, there is this wonderful tool called
qemu... :)

good luck,

greg k-h
