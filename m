Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3ERVFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 17:05:46 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58886 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3ERVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 17:05:45 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 18 May 2013 14:05:23 -0700
X-Google-Sender-Auth: DfGmvZ6v_K8V00Q-KMLhmhBfkzQ
Message-ID: <CAB=NE6VAWUQpbZpM8T77d-r7ZYJd4veghKY_eMV9sDv831gbXw@mail.gmail.com>
Subject: [ANN] Backports based on v3.10-rc1 released
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As announced on the list the compat-drivers project was renamed to
backports [0] and uses now only one new tree for development [1]. Due
to the huge amount of changes we've been behind on linux-next daily
snapshots but we've now caught up with Linus so a release based on
v3.10-rc1 is due and is now available [2]. Please test ! There are
tons of changes in terms of how we do backports that should make it
easier and consistent to backport drivers and subsystems thanks mainly
to Johannes' huge changes. As it is now most if not all development
scripts have been converted to Python, except for scripts required on
the user's part for installation.

As for user's experience you no longer have to use the silly
./scripts/drivers-select script to enable only one driver for
compilation, you just type in

make menuconfig
make -j 4
# Then as root:
make install

There are also a series of defconfigs, present on the defconfig
directory, you can use the iwlwifi defconfig as follows for example:

make defconfig-iwlwifi

We need more defconfigs! Please feel free to send your submissions.
I'm willing to merge these in for the rc series prior to the final
release. Apart from these changes we now also backport three new
subsystems: NFC, media and regulator subsystems. For NFC we have 8 new
drivers. For media we ended up backporting 433 new drivers. For
regulator we backported 37 new drivers.

Many thanks to Johannes, Samuel, and Hauke for their huge help with
all these new changes. Now please go test!

[0] http://marc.info/?l=linux-backports&m=136891011622088&w=2
[1] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/backports.git
[2] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10-rc1/backports-3.10-rc1-1.tar.bz2

  Luis
