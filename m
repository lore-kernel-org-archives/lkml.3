Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3CTJXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:05 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51765 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3CTJXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 00/30] compat: deal with kernel backport namespace
Date: Wed, 20 Mar 2013 02:22:25 -0700
Message-Id: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This patch series deals with the project that aims at
backporting the Linux kernel [0]. If you don't care
for that, at least read this and patch #1, the rest
you can nuke.

Ben reports compat_ namespace is already taken by the
kernel, and while this is slightly true, I rather just
deal with this now and avoid any future issues.

I've chosen backport_. Any nay's?

I've broken this set for easier review to one per kernel
backported. Each patch is test compiled with ckmake [1]
for kernels 2.6.24 - 3.9. I've then test compiled all this
against compat-drivers-2013-03-15, which sucks in Ethernet,
802.11 Bluetooth, and DRM video drivers against linux-next
tag next-20130315 and it all went fine for all kernels
2.6.24 - 3.9.

I suppose the next set here, if we really are adamant about
any possible namespace issues (is it necessary?) is to use
include/linux/backport/ instead of include/linux/compat/ and
likewise rename the compat module to backports as with
COMPAT_* macros.

I'm sending these as RFCs in hopes to get reviews / testing
prior to any radical change, but more importantly in hopes
anyone who cares for maintaining a Linux distribution will
review.

[0] https://backports.wiki.kernel.org
[1] https://git.kernel.org/cgit/linux/kernel/git/mcgrof/compat.git/tree/bin/ckmake

Luis R. Rodriguez (30):
  compat: add LINUX_BACKPORT() for prefixing symbols
  compat: embrace LINUX_BACKPORT() for v2.6.23
  compat: embrace LINUX_BACKPORT() for v2.6.24
  compat: embrace LINUX_BACKPORT() for v2.6.25
  compat: embrace LINUX_BACKPORT() for v2.6.26
  compat: embrace LINUX_BACKPORT() for v2.6.27
  compat: embrace LINUX_BACKPORT() for v2.6.28
  compat: embrace LINUX_BACKPORT() for v2.6.29
  compat: embrace LINUX_BACKPORT() for v2.6.31
  compat: embrace LINUX_BACKPORT() for v2.6.32
  compat: embrace LINUX_BACKPORT() for v2.6.33
  compat: embrace LINUX_BACKPORT() for v2.6.34
  compat: embrace LINUX_BACKPORT() for v2.6.35
  compat: embrace LINUX_BACKPORT() for v2.6.36
  compat: embrace LINUX_BACKPORT() for v2.6.37
  compat: embrace LINUX_BACKPORT() for v2.6.38
  compat: embrace LINUX_BACKPORT() for v2.6.39
  compat: embrace LINUX_BACKPORT() for v3.0
  compat: embrace LINUX_BACKPORT() for v3.1
  compat: embrace LINUX_BACKPORT() for v3.2
  compat: embrace LINUX_BACKPORT() for v3.3
  compat: embrace LINUX_BACKPORT() for v3.4
  compat: embrace LINUX_BACKPORT() for v3.7
  compat: embrace LINUX_BACKPORT() for v3.8
  compat: embrace LINUX_BACKPORT() for cordic
  compat: embrace LINUX_BACKPORT() for crc8
  compat: embrace LINUX_BACKPORT() for kfifo
  compat: embrace LINUX_BACKPORT() for pm_qos_params
  compat: embrace LINUX_BACKPORT() for uidgid
  compat: use backport_ prefix for main compat module calls

 compat/compat-2.6.23.c        |    2 +
 compat/compat-2.6.34.c        |    8 +--
 compat/compat-2.6.34.h        |    4 +-
 compat/compat-2.6.35.c        |    4 +-
 compat/compat-2.6.36.c        |   32 ++++-----
 compat/compat-2.6.37.c        |    4 +-
 compat/compat-2.6.38.c        |    8 +--
 compat/compat-3.1.c           |   12 ++--
 compat/main.c                 |   25 +++----
 compat/pm_qos_params.c        |    4 +-
 include/linux/compat-2.6.23.h |    3 +
 include/linux/compat-2.6.24.h |    5 ++
 include/linux/compat-2.6.25.h |   15 +++--
 include/linux/compat-2.6.26.h |    1 +
 include/linux/compat-2.6.27.h |    5 ++
 include/linux/compat-2.6.28.h |   15 +++--
 include/linux/compat-2.6.29.h |    6 ++
 include/linux/compat-2.6.31.h |   65 +++++++-----------
 include/linux/compat-2.6.32.h |    1 +
 include/linux/compat-2.6.33.h |   24 +++----
 include/linux/compat-2.6.34.h |    8 +--
 include/linux/compat-2.6.35.h |    7 +-
 include/linux/compat-2.6.36.h |   53 ++++++++-------
 include/linux/compat-2.6.37.h |    5 +-
 include/linux/compat-2.6.38.h |    9 +--
 include/linux/compat-2.6.39.h |    3 +-
 include/linux/compat-2.6.h    |   10 +--
 include/linux/compat-3.0.h    |    3 +
 include/linux/compat-3.1.h    |   12 +---
 include/linux/compat-3.2.h    |    1 +
 include/linux/compat-3.3.h    |    1 +
 include/linux/compat-3.4.h    |    2 +
 include/linux/compat-3.7.h    |    7 ++
 include/linux/compat-3.8.h    |    2 +
 include/linux/cordic.h        |    1 +
 include/linux/crc8.h          |    3 +
 include/linux/kfifo.h         |  146 +++++++++++++++++++++++------------------
 include/linux/pm_qos_params.h |    6 ++
 include/linux/uidgid.h        |   16 +++++
 39 files changed, 305 insertions(+), 233 deletions(-)

-- 
1.7.10.4

