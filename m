Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbbA2GF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:05:29 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52922 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbbA2GF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:05:27 -0500
Date: Thu, 29 Jan 2015 11:35:07 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] afs: Migrate to 64-bit timekeeping
Message-ID: <20150129060507.GA3437@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is an attempt to port afs's timekeeping
variables from time_t type to time64_t. AFS uses
get_seconds to store real (wall clock) time in seconds.
The time returned by get_seconds() will overflow on 32-bit systems
in year 2106 and beyond.
This patchset replaces the usage with ktime_get_real_seconds.
Fields that propagate to the inode (mtime_client, mtime_server,
creation) remain untouched, as the inode timestamps are only 32bit.

Tina Ruchandani (2):
  afs: Migrate vlocation fields to 64-bit
  afs: Prevent callback expiry timer overflow

 fs/afs/callback.c  |  7 ++++---
 fs/afs/fsclient.c  |  2 +-
 fs/afs/inode.c     |  7 ++++---
 fs/afs/internal.h  | 11 ++++++-----
 fs/afs/server.c    |  6 +++---
 fs/afs/vlocation.c | 16 +++++++++-------
 6 files changed, 27 insertions(+), 22 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

