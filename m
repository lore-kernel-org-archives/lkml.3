Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3K0ASW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:18:22 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:17887 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3K0ASU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:18:20 -0500
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTzufSIdKK4A==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: nouveau/ NV11: 3.12 freezes if X.org is started headless
Date: Wed, 27 Nov 2013 00:18:09 +0000
User-Agent: KMail/1.13.7 (Linux/3.12-1.slh.3-aptosid-686; KDE/4.8.4; i686; ; )
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <201311262303.26996.s.L-H@gmx.de> <CAKb7UvinEmz4YFoes2w5JJp-sJ_tsDeAWj-Aa5Yw56m2=j3xHw@mail.gmail.com>
In-Reply-To: <CAKb7UvinEmz4YFoes2w5JJp-sJ_tsDeAWj-Aa5Yw56m2=j3xHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201311270018.14980.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 26 November 2013, Ilia Mirkin wrote:
> On Tue, Nov 26, 2013 at 6:03 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> > v3.11 is fine, with and without monitor attached.
> > v3.12 is fine as long as X.org isn't started (but may fail to reboot
> >       cleanly). If a monitor is connected I don't observe any problems,
> >       it freezes without a monitor connected.
> > v3.13-rc1-95-gb975dc3 appears not to freeze without a monitor anymore
> >       (I didn't confirm that it's fine with a monitor attached), but I
> >       end up with the following Oops (this is before X.org is started).
[…]
> > BUG: unable to handle kernel NULL pointer dereference at   (null)
> > IP: [<e0ecaa4e>] _nouveau_clock_init+0x2a/0xaf [nouveau]
[…]
> The oops in 3.13-rc1 should be fixed by applying the equivalent of
> http://cgit.freedesktop.org/~darktama/nouveau/commit/?id=0397aaaa009092427dc60aea8b3c21c00526d8ba

As you expected, the Oops is gone after applying the afforementioned 
patch, 3.13~ now behaves as 3.12 (it freezes, if X.org is started 
without a monitor attached).

> . Also note that libdrm had a bug when compiled with gcc-4.8 for
> pre-nv50 cards, not sure if the fixes have made it to Debian/unstable,
> but you need libdrm-2.4.48+ (or compile it with gcc-4.7/clang).

The libdrm2 version is 2.4.49-2, which -although it has been compiled 
with gcc 4.8.2-5[1]- should be unaffected by this issue. According to 
the ChangeLog the version is at 7ddc98f92f92560e2b52287ae8cf816ca4a057de
and no significant patches[2] have been applied.

> Lastly, another thing to try if you're getting random hangs is booting
> with nouveau.agpmode=0 (and if that helps, seeing if =1 or =2 still
> work ok). If that helps, it can be added to the quirks list.

Unfortunately this doesn't appear to have an effect, with 3.13~ and
the previous patch applied:

# cat /sys/module/nouveau/parameters/agpmode 
0

# init 5
[   73.708490] nouveau W[  PTIMER][0000:01:00.0] unknown input clock freq
system frozen.

Regards
	Stefan Lippers-Hollmann

[1]	https://buildd.debian.org/status/fetch.php?pkg=libdrm&arch=i386&ver=2.4.49-2&stamp=1385480211
[2]	http://anonscm.debian.org/gitweb/?p=pkg-xorg/lib/libdrm.git;a=blob;f=debian/patches/01_default_perms.diff;h=cdba93e19edf40b2b0b56d951a6416c68a0af6f0;hb=HEAD
	http://anonscm.debian.org/gitweb/?p=pkg-xorg/lib/libdrm.git;a=blob;f=debian/patches/02_kbsd_modeset.diff;h=260260925fc692c71d955d6490dabf87905abb51;hb=HEAD
