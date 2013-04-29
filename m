Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab3D2WDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:03:24 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38496 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384Ab3D2WDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <517EEBD1.503@valvesoftware.com>
References: <517B1153.8000401@valvesoftware.com>
	<517B2FB4.30605@redhat.com>
	<20130427024248.GA1229@cmpxchg.org>
	<517EEBD1.503@valvesoftware.com>
Date: Mon, 29 Apr 2013 15:03:22 -0700
X-Google-Sender-Auth: yoC1_I7IhWscmdf_gPTztY0v1XY
Message-ID: <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sonnyrao@chromium.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 2:53 PM, Pierre-Loup A. Griffais
<pgriffais@valvesoftware.com> wrote:
>
> Other than this particular concern, what's the high-level take-away? Is PAE
> support in the Linux kernel a false promise than distros should not be
> shipping by default, if at all? Should it be removed from the kernel
> entirely if these configurations are knowingly broken by commits like this?

PAE is "make it barely work". The whole concept is fundamentally
flawed, and anybody who runs a 32-bit kernel with 16GB or RAM doesn't
even understand *how* flawed and stupid that is.

Don't do it. Upgrade to 64-bit, or live with the fact that IO
performance will suck. The fact that it happened to work better under
your particular load with one particular IO size is entirely just
"random noise".

Yeah, the difference between "we can cache it" and "we have to do IO"
is huge. With a 32-bit kernel, we do IO much earlier now, just to
avoid some really nasty situations. That makes you go from the "can
sit in the cache" to the "do lots of IO" situation. Tough.

Seriously, you can compile yourself a 64-bit kernel and continue to
use your 32-bit user-land. And you can complain to whatever distro you
used that it didn't do that in the first place. But we're not going to
bother with trying to tune PAE for some particular load. It's just not
worth it to anybody.

                Linus
