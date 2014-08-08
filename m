Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaHHWHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:07:52 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36255 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaHHWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzxF8WGM6C9eoqP+Xd+AWRw079s5L_YJd-jJTJGJssi=A@mail.gmail.com>
References: <20140808143418.GA25720@phenom.ffwll.local>
	<CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
	<CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
	<CA+55aFyXXyJ1subAWjwv3-yFndRNpUSWLFVb8Aq=NWAS+PXsJQ@mail.gmail.com>
	<CA+55aFzxF8WGM6C9eoqP+Xd+AWRw079s5L_YJd-jJTJGJssi=A@mail.gmail.com>
Date: Fri, 8 Aug 2014 15:07:37 -0700
X-Google-Sender-Auth: GP4weSbvuqQj-mUyYzD256BpKR0
Message-ID: <CA+55aFwf33qaXA7XY3_=ctzbYZ3gNzJS2-_d_KR-_ANBYkUb_Q@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 1:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Got this while bisecting. I'm not sure it's related

It's not.

The actual bug was panel self refresh. It's still broken, and doesn't
work. So enabling it by default was a big mistake (commit
b6d547791fd3: "drm/i915: Enable PSR by default.")

I've reverted that commit, you guys can try again with PSR for the
next kernel release if somebody figures out how to get the damn thing
*out* of panel self-refresh (because that's what I'm assuming is going
on: the graphics may still work fine, but nothing updates on the panel
any more).

                   Linus
