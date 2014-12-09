Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaLIKAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:00:42 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35119 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaLIKAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:00:39 -0500
Date: Tue, 9 Dec 2014 11:00:35 +0100
From: Johan Hovold <johan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [GIT PULL] MFD for v3.19
Message-ID: <20141209100035.GH14346@localhost>
References: <20141208120058.GI3951@x1>
 <CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 08:06:11PM -0800, Linus Torvalds wrote:
> On Mon, Dec 8, 2014 at 4:00 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> > Johan Hovold (4):
> >       mfd: Use mfd_add_hotplug_devices() helper
> 
> This clashed with the earlier fix "mfd: viperboard: Fix
> platform-device id collision" also by Johan.
> 
> My merge resolution ends up taking the mfd_add_hotplug_devices() version.
> 
> See drivers/mfd/viperboard.c, and somebody should double-check and
> test that this actually works. The "Fix platform-device id collision"
> commit supposedly fixed a problem with multiple boards, I'm
> hoping/assuming that the mfd_add_hotplug_devices() helper handles that
> case correctly.

The end result is correct since, as you assumed,
mfd_add_hotplug_devices() handles that case.

Just discussed this with Lee. The original patch adding the helper was
on top of the fix, but the latter never made it into mfd-next.

Not sure what happened to the git history after your merge, though,
since commit

	b6684228726c ("mfd: viperboard: Fix platform-device id collision")

no longer shows up when doing

	git log origin/master -- drivers/mfd/viperboard.c

and the diff of

	1ab589c72ef6 ("mfd: Use mfd_add_hotplug_devices() helper")

looks like the first patch has never been applied, even though it is
listed when doing "git log origin/master".

Johan
