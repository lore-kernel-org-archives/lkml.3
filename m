Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaLCPq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:46:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55312 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLCPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:46:55 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Dec 2014 15:46:34 +0000
X-Google-Sender-Auth: qirxjzD1Izpxkve-E-X3OKk5Cj8
Message-ID: <CACxGe6uENpFc7ARarxo3_AfrzejVsyqm0WRN4ovJk5M4NfZjJw@mail.gmail.com>
Subject: [GIT PULL] devicetree bug fix for v3.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One more bug fix for v3.18. I debated whether or not to send you this
merge request because we're at such a late rc. The bug isn't critical
in that there is only one system known to be affected and the patch is
easy to backport. The codepath is used by pretty much every DT based
system, so there is risk a of regression (it /should/ be safe, but
I've been bitten by stuff that should be safe before). I've had it in
linux-next for a week and haven't received any complaints.

I think it probably should just be merged right away rather than
waiting for the merge window and backporting. It does fix a real bug
and the code is theoretically safer after the change. I can't think of
any situation where it would be dangerous to reserve the DT memory an
extra time. However, I won't be upset if you feel differently and
decide not to pull. If that's the case then I'll add it to my queue
for v3.19.

Cheers,
g.

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux
tags/devicetree-for-linus

for you to fetch changes up to 094cb98179f19b75acf9ff471daabf3948ce98e6:

  of/fdt: memblock_reserve /memreserve/ regions in the case of partial
overlap (2014-11-26 12:35:52 +0000)

----------------------------------------------------------------
Devicetree bugfix for v3.18

Single bugfix for boot failure seen in the wild. The memory reserve code
tries to be clever about reserving the FDT, but it should just go ahead
and reserve it unconditionally to avoid the problem of partial overlap
described in the patch.

----------------------------------------------------------------
Ian Campbell (1):
      of/fdt: memblock_reserve /memreserve/ regions in the case of
partial overlap

 drivers/of/fdt.c | 2 --
 1 file changed, 2 deletions(-)
