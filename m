Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3JJCiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:38:55 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:52760 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3JJCiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<20131008080625.GA25034@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
Date: Wed, 9 Oct 2013 19:38:53 -0700
X-Google-Sender-Auth: poLXPJ2DHin32ZsNEMCd32FhOYI
Message-ID: <CA+55aFxTeTOpvE7+rKD=0i0Qdn408bFCck5Eo_we=CX58UJP9Q@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 7:23 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> Well the commit that added it had a reason that seems to cover some other
> device model abuses, so maybe someone who actually understands the device
> model (all 2 people) can review usage

Actually, I think it's the same bug.

You *cannot* just reuse the storage. Doing a "memset()" doesn't
improve anything. The basic issue is that if you reuse it, you're
buggy. End of story.

Why? It's refcounted, and it's out of your hands. Reusing it is wrong
- because it might still be used. The fact that you "released" it is
immaterial. Others can have refcounts (and through /sys etc,
historically really do have them).

            Linus
