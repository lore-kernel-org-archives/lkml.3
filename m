Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3IRRS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:18:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17798 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3IRRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:18:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YbEfaroPEgpoIaPVLcItt
Date: Wed, 18 Sep 2013 10:18:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Message-ID: <20130918171816.GT9994@atomide.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
 <20130917232417.GK9994@atomide.com>
 <201309181033.24965@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309181033.24965@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130918 01:41]:
> 
> I'm not very happy. I sent this patch 6 months ago and only now 
> you commented that needs rework again. This patch is needed 
> because all thumb-2 userspace binaries crashing. I want to have
> working support for Nokia N900 and not always rebasing and 
> changing patches. Also DT still not working on N900 (file contains 
> only small subset of devices as in board files plus it is not in 
> stable kernel) so I do not want to switch to DT. I need something 
> which is working and not something new non-working. I belive that 
> you and other kernel guys do not remove all n900 board files until 
> every one line will be rewritten to DT and tested that everything 
> working. And from this and other conversation it looks for me 
> that you are going to do that. So please clarify what you want to 
> do (and when) with board-rx51-* files. Aftethat I can decide what 
> to do in future.

Sorry if there's been some going back and forth with the patches,
I think pretty much everybody wants n900 support in the mainline.

It's obvious that we're moving everything to be devicetree only
as discussed on the mailing lists over past few years. For most
drivers it's already working, and we can still initialize platform
data too for the legacy devices until they have bindings, so it
should not be too intrusive except for the configuration changes
to use appended DTB or a chained bootloader with DTB support.

> For now I see this situation something like: I wrote patches, 
> send them to ML and after half of year maintainer politely 
> rejected them becuase my patches not using new uber cool 
> technology with still not working and also was not available half 
> year ago. What happen if I find another time to rework this patch 
> and send it again in next 2 or 5 months?

Hmm hasn't there been pending comments until recently on your
patches?

It seems that with the changes I suggested your patches should
work for both legacy booting and DT based booting, so maybe just
try to update them over next few weeks, let's say by -rc3 rather
than wait 2 to 5 months? :) No need to test them currently on
the DT based booting if you don't have that set up, just move
the code out of the board-*.c file.
 
> Tony, if you did not have time for review this patch months ago 
> or you found it only today - no problem, I understand it. But 
> what I need to know is what will happen with board-rx51-* files 
> (and when?) You can see that DT does not have definitions of all 
> n900 hw parts (plus it is not in last 3.11 kernel!) which means 
> that DT is not usable for me and other n900 people. This also 
> means that I cannot rewrite my patches for DT and test if they 
> working.

I usually stop looking at new code around -rc4 and concentrate
on fixes until -rc1 or so. So there can be easily one month
delays on reviewing stuff depending on where we are with the
current merge window or -rc cycle, sorry if that's annoying.

The .dts files will be separate from the kernel soonish, so
that's not be a show stopper. Just like all the board specific
.config files are separate from the kernel already. Too bad our
.dts changes did not get merged for v3.12 because of conflicts
with other branches, but hey, they should be independent from the
kernel anyways.

The board files will be going away as soon as things are working
with DT. We've been pretty much only applying fixes to them for
quite some time now. For the timeline, the earliest we'll be able
to remove the board-*.c files and platform data is for v3.13
assuming the PM dependencies get sorted out before that. Making
omap3 DT only is going remove about 25k LOC, so that's a good
reason for doing that.

Cheers,

Tony
