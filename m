Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaHIIoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:44:30 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:45975 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaHIIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:44:25 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CA+55aFwf33qaXA7XY3_=ctzbYZ3gNzJS2-_d_KR-_ANBYkUb_Q@mail.gmail.com>
References: <20140808143418.GA25720@phenom.ffwll.local>
	<CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
	<CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
	<CA+55aFyXXyJ1subAWjwv3-yFndRNpUSWLFVb8Aq=NWAS+PXsJQ@mail.gmail.com>
	<CA+55aFzxF8WGM6C9eoqP+Xd+AWRw079s5L_YJd-jJTJGJssi=A@mail.gmail.com>
	<CA+55aFwf33qaXA7XY3_=ctzbYZ3gNzJS2-_d_KR-_ANBYkUb_Q@mail.gmail.com>
Date: Sat, 9 Aug 2014 10:44:24 +0200
Message-ID: <CAKMK7uHKDb5mJjiF=Ga6HYLjxb-bDJYy27uTs=UK-YevOfuP4Q@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 12:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 8, 2014 at 1:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Got this while bisecting. I'm not sure it's related
>
> It's not.

Iirc it was an intermediate merge issue between two patch series. If
you still see this on your tip, please scream. The warning is just one
of our modeset sequence asserts firing.

> The actual bug was panel self refresh. It's still broken, and doesn't
> work. So enabling it by default was a big mistake (commit
> b6d547791fd3: "drm/i915: Enable PSR by default.")
>
> I've reverted that commit, you guys can try again with PSR for the
> next kernel release if somebody figures out how to get the damn thing
> *out* of panel self-refresh (because that's what I'm assuming is going
> on: the graphics may still work fine, but nothing updates on the panel
> any more).

A bit surprising since the only psr issue I was aware of was that we
failed to entire psr (and that is likely a fumble in the tracking of
cursor updates). Otoh PSR isn't enabled on baytrail because it's
hang-happy there and the testcase we have for all the corner-cases in
psr tracking turned out to be completely broken and no on fixed this
yet. Anyway thanks for digging this up and pushing the revert
yesterday - I was already in w/e mode ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
