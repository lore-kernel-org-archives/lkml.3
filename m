Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaHKKA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:00:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46698 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752097AbaHKKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:00:55 -0400
Date: Mon, 11 Aug 2014 11:00:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Inki Dae <daeinki@gmail.com>,
        Olof Johansson <olof@lixom.net>, YoungJun Cho <yj44.cho@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: linux-next: build failures after merge of the drm tree
Message-ID: <20140811100017.GA30401@n2100.arm.linux.org.uk>
References: <20140805130926.4e8c8fe5@canb.auug.org.au> <53E0736E.7030901@samsung.com> <CAOesGMjjLHOaBJZwFENaWW41KFsNZ3pUqiYk0jtet=8NFvce3g@mail.gmail.com> <CAOesGMg=kFM_9ksgoOXgqLFjzoE38tCuPy7pxbG5F_j5KovkVA@mail.gmail.com> <alpine.DEB.2.00.1408100856270.32072@skynet.skynet.ie> <CAK5sBcHceBqYQOQrWw9D0CviVpnXOdAtfgh7pFkT=L53Gfbe6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5sBcHceBqYQOQrWw9D0CviVpnXOdAtfgh7pFkT=L53Gfbe6g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 09:26:00AM +0530, Sachin Kamat wrote:
> On Sun, Aug 10, 2014 at 1:28 PM, Dave Airlie <airlied@linux.ie> wrote:
> >>
> >
> > Been on holidays, but ack for anything DT related,
> >
> > Look I wishI knew how DT worked, and what tree is canonical for changes to
> > it, I'm not sure its well defined enough or sub maintaniers know enough,
> > so I do just trust the exynos guys with this.
> >
> 
> Inki,
> 
> Can you please get your tree included in linux-next so that these kind of
> issues could be detected much earlier (even before they hit Dave's tree)?

The answer is not always "stuff your tree into linux-next", but it can
be "learn what's required of maintaining a git tree and/or patch sets".

arm-soc people have asked for a long time that DT updates should go via
themselves rather than through subsystem trees because conflicts there
are rather horrid to deal with, and it's very easy for things to end up
getting out of hand.

Moreover, stuffing a tree into linux-next can cause more harm than good
if the tree owner does not respect the kernel development cycle.  For
example, I notice today that we have new breakage which has appeared in
linux-next which seems to be a change which was never even _compile
tested_ before it was became visible to linux-next, because builds
complain about misplaced ";" and "}".

linux-next is not a build-testing tree; it is an integration tree - it's
there to help tree maintainers find /conflicts/ between their development
trees and resolve those conflicts.  It is not a subsitute for proper
compile testing, it is also not a subsitute for talking to your fellow
developers, and it certainly is not a subsitute for knowing where in the
kernel development cycle things are and knowing what the implications of
that mean for linux-next (and if your tree is part of linux-next, what
it will also mean for /your/ tree.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
