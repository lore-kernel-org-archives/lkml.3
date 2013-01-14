Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3ANMyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:54:02 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63041 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3ANMyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:54:00 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 14 Jan 2013 13:53:58 +0100
Message-ID: <CA+icZUVYukvCX+08Yr1ggj6u2zmvuvoGE8noPiwnBdYWv0zjMA@mail.gmail.com>
Subject: Re: -next: no resume from suspend
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

[ QUOTE ]
since friday's -next (the last known to be working is the last monday's)
I cannot resume from suspend. The last thing I see with
no_console_suspend is:
i915: No ACPI video bus found

But I used to see the message always, so this is no difference. Any idea
before I start bisecting?

It is x86_64, core 2 duo, intel g33 GPU, 6G RAM.
[ /QUOTE ]

Before starting any git-bisection I would try drm-intel-nightly GIT branch.
It includes drm-intel-fixes + drm-intel-next + drm-intel-next-queued
and applied here (mostly) cleanly against Linux (upstream) and/or
Linux-Next.

$ cd linux-next/

$ git pull git://people.freedesktop.org/~danvet/drm-intel drm-intel-nightly

I remember I had no problems with i915 with next-20130109 (WED) and
next-20130110 (THU), so I am curious if I will hit the problem as
well.

Kernel-config and some logs (dmesg) or hwinfos (lspci) might be helpful :-).

If this does not help, I would recommend to create diffs between
latest known (-rcX and next-X.good) and (-rcX and next-X.bad) and
compare (i915||acpi||pm) the changes.
But this also means you have to know which of the -next releases was
good and bad.
If you are building Linux-Next daily, this is good.
NOTE: Helpful is in this strategy that your -rcX should be the same
(here: v3.8-rc3).

Hope this helps you (I know bisecting Linux-Next is a bit of a pain).

Regards,
- Sedat -

[1] http://cgit.freedesktop.org/~danvet/drm-intel/log/?h=drm-intel-nightly
