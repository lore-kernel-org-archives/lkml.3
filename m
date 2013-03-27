Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3C0QwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:52:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57352 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3C0QwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:52:16 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1889932.BuDOlJCg10@photon>
References: <20130318210510.203500214@linuxfoundation.org>
	<20130318210515.597927833@linuxfoundation.org>
	<1889932.BuDOlJCg10@photon>
Date: Wed, 27 Mar 2013 17:52:15 +0100
Message-ID: <CAKMK7uEjVdU08aq9_sROD=ddkvVYBDqAyMM-5_CC3+x8Qe7-SA@mail.gmail.com>
Subject: Re: [ 74/75] Revert "drm/i915: enable irqs earlier when resuming"
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Ilya Tumaykin <itumaykin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 4:45 PM, Ilya Tumaykin <itumaykin@gmail.com> wrote:
> On 18.03.13 14:07:37 Greg Kroah-Hartman wrote:
>> 3.8-stable review patch.  If anyone has any objections, please let me know.
>
> Hello, Greg.
>
> The original "drm/i915: enable irqs earlier when resuming" commit was
> introduced in order to fix bug appeared in 3.8 kernels. Reverting this commit
> you also bring back that bug. Bugzilla link:
> https://bugzilla.kernel.org/show_bug.cgi?id=54691#c17
>
> Sorry for late reply, I wasn't sure if this is simple revert or another
> mechanism was introduced by devs to avoid mentioned bug and that fix became
> unnecessary. Please undo this revert.

Nack.

This thing blew up all over the place and caused about 5 different
regressions. It works all correctly in 3.9 due to the different
context (completely revamped init sequence around irq handling).

I realize that this means that ilk rc6 is broken in 3.8 (and we can't
really fix it without either going back to the ilk rc6 code in 3.6 or
copying the entire 3.9 irq init sequence, both a bit too intrusive for
stable). But:
- ilk rc6 is known to hang machines
- ilk rc6 is (opposed to rc6 on snb+) not know to do anything good
like safe power

And so disabled by default. So I hope that regression is bearable,
feel free to beat the drm/i915 guys as usual for their failings ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
