Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaE2A0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:26:55 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32899 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaE2A0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140528234927.GA18638@milliways>
References: <20140528172521.GA9945@milliways>
	<20140528234927.GA18638@milliways>
Date: Wed, 28 May 2014 20:26:53 -0400
Message-ID: <CADnq5_PWigm5e4CwnfW+3TaohbFo82uDpiCMftL=OmRvCkJQzQ@mail.gmail.com>
Subject: Re: Resume from suspend broken in 3.15. (bisected)
From: Alex Deucher <alexdeucher@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 7:49 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> On Wed, May 28, 2014 at 06:25:21PM +0100, Ken Moffat wrote:
>> Hi Daniel,
>>
>
>  [ correcting details, confirming that reverting this does fix the
> problem, adding Cc:s ]
>
>>  I've only started full testing of 3.15 on one of my machines now
>> that -rc7 has been released (this one had two issues in the radeon
>> code, second was fixed in rc7).  Unfortunately, suspend to RAM
>> (pm-suspend), or rather the wake-up, is broken on this box [ my
>> other two boxes are fine in rc7 ].
>>
>> Bisection identified one of your commits -
>>
>> commit 25f397a429dfa43f22c278d0119a60a343aa568f
>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Date:   Fri Jul 19 18:57:11 2013 +0200
>>
>>     drm/crtc-helper: explicit DPMS on after modeset
>>
>>     Atm the crtc helper implementation of set_config has really
>>     inconsisten semantics: If just an fb update is good enough, dpms state
>>     will be left as-is, but if we do a full modeset we force everything to
>>     dpms on.
>>
>>     This change has already been applied to the i915 modeset code in
>>
>> ('git show' stops at that point)
>
>  update : I've no idea what was going on there, nor for the problem
> with attempting to revert it.  I've now gone back into git,
> extracted the full commit to a file with 'git show', and then used
> git apply -R to revert it from 3.15-rc7.  That version wakes up from
> suspend to RAM, 3.15-rc7 itself did not.
>
>  Maybe I was still in git log when I thought I was on the command
> line.  Anyway, snipping git's view of my failed attempt to revert
> it, and adding Dan and Alex who were CC'd on the commit.
>

Duplicate of:
https://bugzilla.kernel.org/show_bug.cgi?id=74751
and also reported here:
https://lkml.org/lkml/2014/5/2/388
Unless there is a good reason to keep the commit, I'd say let's just revert it.

Alex

>>
>>  The processor is an AMD A4 APU.  The symptoms after this commit are
>> that pm-suspend works (I invoke it from my keyboard's sleep key),
>> i.e. the power LED on the case goes out and the monitor goes black
>> and reports no signal.  When I press a key to resume, the power LED
>> comes on but the screen stays black.  Magic-SysRQ does not work and
>> I have to use the case switch to reboot.  That results in filesystem
>> errors which fsck fixes and warns about (probably, just a sign of
>> unclean shutdown).
>>
>>  The only thing in the log are a couple of messages from EXT4 at the
>> end of putting the box to sleep -
>> May 28 16:19:02 bluesbreaker kernel: [   39.440859] EXT4-fs (sda10): re-mounted. Opts: commit=0
>> May 28 16:19:02 bluesbreaker kernel: [   39.592318] EXT4-fs (sda13): re-mounted. Opts: commit=0
>> May 28 16:20:05 bluesbreaker syslogd 1.5.0: restart.
>>
>>  What can I do to help debug this ?
>>
> ĸen
> --
> Nanny Ogg usually went to bed early. After all, she was an old lady.
> Sometimes she went to bed as early as 6 a.m.
