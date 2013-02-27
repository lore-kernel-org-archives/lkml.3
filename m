Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab3B0X1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:27:32 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37459 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3B0X1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAAMvbhFTNmUS-usRZKBEqp_YrpxDhckj9tdTtC+m_5EnO+UECw@mail.gmail.com>
References: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
	<CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
	<20130225223243.GA18744@kroah.com>
	<20130226034545.GA1089@kroah.com>
	<20130226173514.GA24136@kroah.com>
	<CAAMvbhFTNmUS-usRZKBEqp_YrpxDhckj9tdTtC+m_5EnO+UECw@mail.gmail.com>
Date: Wed, 27 Feb 2013 23:27:30 +0000
Message-ID: <CAAMvbhEAcLuE+5KGP13wCc8nVBp1Eq-UPtaUD7c5oGVq8io8Lw@mail.gmail.com>
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>, Martin Peres <martin.peres@labri.fr>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2013 18:11, James Courtier-Dutton <james.dutton@gmail.com> wrote:
> On 26 February 2013 17:35, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Feb 25, 2013 at 07:45:45PM -0800, Greg KH wrote:
>>> On Mon, Feb 25, 2013 at 02:32:43PM -0800, Greg KH wrote:
>>> > On Mon, Feb 25, 2013 at 04:06:02PM +1000, Dave Airlie wrote:
>>> > > On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> > > > Hi Ben,
>>> > > >
>>> > > > My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
>>> > > > down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
>>> > > > move link training helpers into core as display methods)
>>> > > >
>>> > > > Anything I can try to help solve this?
>>> > > >
>>> > > > Note, I'm using the Intel driver as the main controller for this laptop,
>>> > > > well, I think I am, my xorg log is attached.
>>> > >
>>> > > No you are using the nvidia, the efi always boots nvidia enabled now.
>>> >
>>> > Really?  When did that change?  I thought I wanted to be using the Intel
>>> > chip to save battery life.
>>> >
>>> > > btw I just tested my drm-next tree on mine and it resumed the display
>>> > > fine, something oopsed a few seconds later that I haven't tracked down
>>> > >
>>> > > git://git.freedesktop.org/~airlied/linux drm-next
>>> > >
>>> > > I'll be sending it to Linus this evening or tomorrow morning, once I
>>> > > fix my tree.
>>> >
>>> > Ok, I'll test again when it hits Linus's tree, and if that works, it
>>> > would be good to try to work out what patch fixes it to get them into
>>> > the 3.8-stable series so that others don't run into the same problem.
>>>
>>> I've tested Linus's tree now (I'm guessing it has all of your changes in
>>> it), and it works!
>>>
>>> I see a bunch of patches marked for the stable branch, so I'll try those
>>> out and see if they fix the problem.  If not, I'll let you and Ben know.
>>
>> I've applied the radeon patches tagged for -stable and tested that on
>> 3.8.0, but that doesn't solve the resume problem.  Any ideas of anything
>> else I can do to test this?  Doing a "backwards" git-bisect is a pain,
>> but I guess I can do that to try to track down what patch fixed this, if
>> that's the only idea people have...
>>
>
> If it helps, I have a similar resume problem here.
> 3.7.8 good
> 3.8.0 bad
>
> Laptop with no nvidia, no amd graphics, just Intel Graphics 4000, 3rd
> Gen I5 CPU.

Problem: "Backlight not coming on after resume."
git finally bisected  for my Samsung Serial 7 Laptop.
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[cf0a6584aa6d382f802f2c3cacac23ccbccde0cd] drm/i915: write backlight
harder     <- This is the problem commit. Seems that fixing some
machines breaks others, based on the existing comments on that patch.

git bisect log
git bisect start
# bad: [09884964335e85e897876d17783c2ad33cf8a2e0] mm: do not grow the
stack vma just because of an overrun on preceding vma
git bisect bad 09884964335e85e897876d17783c2ad33cf8a2e0
# good: [6c5096e5538b455bc3bea2b02588c380f070d8c6] Merge tag 'boards'
of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 6c5096e5538b455bc3bea2b02588c380f070d8c6
# good: [21fbd5809ad126b949206d78e0a0e07ec872ea11] Merge branch
'v4l_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 21fbd5809ad126b949206d78e0a0e07ec872ea11
# bad: [fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb] Merge branch
'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect bad fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb
# bad: [b81e059ec5a7128622ab5d74d78e9b4f361b54ae] Merge branch
'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel
into drm-next
git bisect bad b81e059ec5a7128622ab5d74d78e9b4f361b54ae
# good: [d6dd9eb1d96d2b7345fe4664066c2b7ed86da898] drm/i915: dynamic
Haswell display power well support
git bisect good d6dd9eb1d96d2b7345fe4664066c2b7ed86da898
# good: [73ccd6962fff19e53a7d4baaa17cf9311284ac9c] Merge branch
'drm-next-3.9' of git://people.freedesktop.org/~agd5f/linux into
drm-next
git bisect good 73ccd6962fff19e53a7d4baaa17cf9311284ac9c
# good: [a4462f246c8821f625f45bce52c7ca7e0207dffe] staging/omapdrm:
Use kmemdup rather than duplicating its implementation
git bisect good a4462f246c8821f625f45bce52c7ca7e0207dffe
# bad: [d84f031bd230fdf9c3b7734940c859bf28b90219] drm: Use C8 instead
of RGB332 when determining the format from depth/bpp
git bisect bad d84f031bd230fdf9c3b7734940c859bf28b90219
# bad: [f73f760725636b9d0c3786273e185b053516d1eb] drm/i915/ctx: Remove
bad invariant
git bisect bad f73f760725636b9d0c3786273e185b053516d1eb
# bad: [26739f12cf210cb8df35969258a1f064e8e12b63] drm/i915: unify
HDMI/DP hpd definitions
git bisect bad 26739f12cf210cb8df35969258a1f064e8e12b63
# good: [b8efb17b3d687695b81485f606fc4e6c35a50f9a] i915: ignore lid
open event when resuming
git bisect good b8efb17b3d687695b81485f606fc4e6c35a50f9a
# bad: [07ea0d85ac8adb87b817913d9720e3c76171b1f6] drm/i915: Clarify HW
context size logic
git bisect bad 07ea0d85ac8adb87b817913d9720e3c76171b1f6
