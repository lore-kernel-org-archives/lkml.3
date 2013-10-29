Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3J2Sk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:40:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14123 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3J2Skz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:40:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bh+LEodowxxsnaNsw5T9g
Date: Tue, 29 Oct 2013 11:40:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Daniel Walker <dwalker@fifo99.com>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131029184044.GF15154@atomide.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <20131029170817.GA13047@fifo99.com>
 <CAOesGMgKbreaqFTGvC=_T6-i7uejfXAPNU8LmMpgDMqeEwYxZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgKbreaqFTGvC=_T6-i7uejfXAPNU8LmMpgDMqeEwYxZQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [131029 10:40]:
> On Tue, Oct 29, 2013 at 10:08 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > Personally I think splitting mach- stuff isn't very useful or
> > interesting.. There's just no technical reason for it, for example x86
> > and x86_64 was a win from my perspective , there's a lot more reason to
> > keep similar things together than to split things up.
> 
> There are definitely valid technical reasons for it; the old and new
> platforms share no code, and the legacy platforms are unlikely to be
> updated to modern infrastructure anytime soon. Other platforms are
> managed in similar manners, such as OMAP, imx/mxs, etc.

Yeah there are still few valid reasons to have separate mach directories.

The main reason why mach-omap2 was originally set up separately from
mach-omap1 was because the IO space was different. And we could not
properly deal with that until CONFIG_ARM_PATCH_PHYS_VIRT few years ago.

So we placed the shared code into plat-omap, which worked OK but is
not really needed any longer with device tree. We have only dmtimer
and legacy DMA code left in plat-omap pretty much. And those will be
moved to live under drivers/.

Even with most issues fixed, it still does not not make sense to merge
mach-omap1 and mach-omap2. For example, even if somebody wanted to do it
as a hobby project, we'd have to compile things with v4 or v5 flags,
which won't work properly for SMP cores at least :)

Regards,

Tony
