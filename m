Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaABEOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 23:14:04 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:41857
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaABEOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 23:14:03 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2014 23:14:02 EST
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=LcaDllckn3IA:10 a=Rttt9Z-za7sA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=-PkhLDywX0wA:10
 a=teh0C3kBIIw93_vd0fsA:9 a=QEXdDO2ut3YA:10
Date: Thu, 2 Jan 2014 04:08:15 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect
 failed
Message-ID: <20140102040815.GA25619@milliways>
References: <201401011752.00267.gheskett@wdtv.com>
 <20140102001900.GC19878@titan.lakedaemon.net>
 <201401012125.55522.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201401012125.55522.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 09:25:55PM -0500, Gene Heskett wrote:
> On Wednesday 01 January 2014, Jason Cooper wrote:
> >
> >Are the rootfs binaries 32 bit?  If so, did you enable
> >CONFIG_IA32_EMULATION?
> 
> That line above does not now exist in my .config for 3.8.2. Ditto for 
> the .config in 3.12.6.
> 
> How is the best way to restore this?
> 
 but Jason also wrote:

> >You may be able to bypass your PAE problem by running a 64bit kernel
> >with the above option.  Although, I'd prefer to get to the bottom of the
> >failure. :)
> >

Gene -

 If I've understood you correctly, you are now running a 32-bit
kernel - or perhaps 32-bit with PAE.  The CONFIG_IA32_EMULATION
option is for a 64-bit [ x86_64 ] kernel, to enable it to run 32-bit
userspace (either only 32bit userspace, or multilib).  So, it is
irrelevant for a 32-bit kernel - those can only run 32-bit
userspace.

 If your previous "good" kernel was either 32-bit or 32-bit with PAE,
you might need to change a lot of .config settings to get a reliably
working 64-bit kernel.  And vice-versa for a well-adapted 32-bit
kernel if you had previously been running 64-bit.

 Your main problem appears to be that part of kde is unusable, and
you attribute this to the old firmware.  That may well be true (I
don't use kde), but I will be very surprised if that is the
_expected_ result of running the old firmware on an early phenom.
Usually, running old firmware doesn't seem to make a lot of
difference, except in obscure corner cases.  I will note that my own
phenom *sometimes* seems to lose its lunch when running make -j4,
and in those cases dropping the caches and running a
less-adventurous parallel make [ -j3 or -j2 ] seems to fix it.  But
that doesn't seem to be analagous to the kde problem you see (and
when I last looked, a few months ago, my firmware appeared to be
current, so I guess mine is the common "cheap consumer hardware" sort
of problem).

 Anyway, best of luck and I hope you get it sorted.

 Perhaps I should also upset you by mentioning that 3.8 seems to be
out of maintenance (except, probably, from ubuntu).  In general, the
devs here aren't too interested in old kernels which are no longer
supported.  OTOH, I'm reluctant to suggest what I would normally
suggest in the "distro" (LFS) I care about - i.e. try both 3.12.0 and
3.12.latest, both from a known good .config using 'make oldconfig' -
because you are starting from an old version and it isn't obvious
where the problem started.  Those of us with specific requirements
really need to keep checking each kernel release (or ideally some of
the later -rc versions) to make sure that things we care about
haven't been trashed.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
