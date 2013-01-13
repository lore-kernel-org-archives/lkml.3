Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3AMACv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 19:02:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3AMACt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 19:02:49 -0500
Date: Sun, 13 Jan 2013 01:02:42 +0100
From: Borislav Petkov <bp@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20130113000242.GD10630@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
	Sasha Levin <levinsasha928@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Tobias Schandinat <florianSchandinat@gmx.de>
References: <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
 <20121227045301.GB17472@x1.alien8.de>
 <20121228115022.GA28009@S2101-09.ap.freescale.net>
 <20121228124026.GB12918@x1.alien8.de>
 <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
 <20130112183619.GC10630@liondog.tnic>
 <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
 <20130112131323.31d2a585.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130112131323.31d2a585.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 01:13:23PM -0800, Andrew Morton wrote:
> Florian has been taking a month or two's downtime (now expired, I
> think) so I've been waiting for him to reappear to process this one for
> 3.8.
> 
> Meanwhile, I guess we could put it into mainline ;) It has been in
> -next for a month.
> 
> From: Alan Cox <alan@linux.intel.com>
> Subject: fb: rework locking to fix lock ordering on takeover
> 
> Adjust the console layer to allow a take over call where the caller
> already holds the locks.  Make the fb layer lock in order.
> 
> This is partly a band aid, the fb layer is terminally confused about the
> locking rules it uses for its notifiers it seems.
> 
> [akpm@linux-foundation.org: remove stray non-ascii char, tidy comment]
> [akpm@linux-foundation.org: export do_take_over_console()]
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Yes, that's the one, modulo Andrew's fixes, which I've been running.
Irregardless, I'll run this one tomorrow just in case, because it
triggers here so easily.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
