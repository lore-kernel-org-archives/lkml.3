Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaABExT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 23:53:19 -0500
Received: from mail.wdtv.com ([66.118.69.84]:55191 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaABExS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 23:53:18 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
Date: Wed, 1 Jan 2014 23:53:14 -0500
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
References: <201401011752.00267.gheskett@wdtv.com> <201401012125.55522.gheskett@wdtv.com> <20140102040815.GA25619@milliways>
In-Reply-To: <20140102040815.GA25619@milliways>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201401012353.15469.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 January 2014, Ken Moffat wrote:
>On Wed, Jan 01, 2014 at 09:25:55PM -0500, Gene Heskett wrote:
>> On Wednesday 01 January 2014, Jason Cooper wrote:
>> >Are the rootfs binaries 32 bit?  If so, did you enable
>> >CONFIG_IA32_EMULATION?
>> 
>> That line above does not now exist in my .config for 3.8.2. Ditto for
>> the .config in 3.12.6.
>> 
>> How is the best way to restore this?
>
> but Jason also wrote:
>> >You may be able to bypass your PAE problem by running a 64bit kernel
>> >with the above option.  Although, I'd prefer to get to the bottom of
>> >the failure. :)
>
>Gene -
>
> If I've understood you correctly, you are now running a 32-bit
>kernel - or perhaps 32-bit with PAE.  The CONFIG_IA32_EMULATION
>option is for a 64-bit [ x86_64 ] kernel, to enable it to run 32-bit
>userspace (either only 32bit userspace, or multilib).  So, it is
>irrelevant for a 32-bit kernel - those can only run 32-bit
>userspace.

That is one of the hills I am trying to climb.

> If your previous "good" kernel was either 32-bit or 32-bit with PAE,
>you might need to change a lot of .config settings to get a reliably
>working 64-bit kernel.  And vice-versa for a well-adapted 32-bit
>kernel if you had previously been running 64-bit.

All of my previous "good" kernels were 32 bit with or without PAE.  The 
important one is 2.6.32-122-rtai which is what it takes to run linxcnc, 
which I need to do for simulation runs occasionally.  That is what I am 
booted to ATM, but its a poor kernel for busy desktops, not PAE because 
that is a speed hit.  We are fixing that, but it hasn't dribbled down the 
hill to me yet, still "alpha" and these guys don't even want to ship Beta.

> Your main problem appears to be that part of kde is unusable, and
>you attribute this to the old firmware.  That may well be true (I
>don't use kde), but I will be very surprised if that is the
>_expected_ result of running the old firmware on an early phenom.
>Usually, running old firmware doesn't seem to make a lot of
>difference, except in obscure corner cases.  I will note that my own
>phenom *sometimes* seems to lose its lunch when running make -j4,

I've also found that, so my makefiles use -j3 and are ok AFAIK.

>and in those cases dropping the caches and running a
>less-adventurous parallel make [ -j3 or -j2 ] seems to fix it.  But
>that doesn't seem to be analagous to the kde problem you see (and
>when I last looked, a few months ago, my firmware appeared to be
>current, so I guess mine is the common "cheap consumer hardware" sort
>of problem).

Like me, you didn't buy the superdooper overclocked version. :)  This 9550 
is running at about 2.1Ghz and seems happy as a clam doing it.  I think 
you'd call it cheap consumer stuff.................

> Anyway, best of luck and I hope you get it sorted.
>
> Perhaps I should also upset you by mentioning that 3.8 seems to be
>out of maintenance (except, probably, from ubuntu).  In general, the
>devs here aren't too interested in old kernels which are no longer
>supported.  OTOH, I'm reluctant to suggest what I would normally
>suggest in the "distro" (LFS) I care about - i.e. try both 3.12.0 and
>3.12.latest, both from a known good .config using 'make oldconfig' -
>because you are starting from an old version and it isn't obvious
>where the problem started.

I don't have any tarballs between 3.8.3 and 3.12.0 locally.  Perhaps a 
better starting point suggestion since I do know how to run gftp?

>Those of us with specific requirements
>really need to keep checking each kernel release (or ideally some of
>the later -rc versions) to make sure that things we care about
>haven't been trashed.

Yes Mike, I've been following your messages on this list for much of a 
decade.  Occasionally pretty pointed too. ;-)
>
>ĸen


Cheers, Gene
