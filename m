Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaJGWda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:33:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJGWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:33:29 -0400
Date: Tue, 7 Oct 2014 15:33:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Don A. Bailey" <donb@securitymouse.com>
Subject: [GIT PULL] Compression patches for 3.18-rc1
Message-ID: <20141007223328.GA5588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git tags/compress-3.18-rc1

for you to fetch changes up to 72cf90124e87d975d0b2114d930808c58b4c05e4:

  lzo: check for length overrun in variable length encoding. (2014-09-28 11:08:01 +0200)

----------------------------------------------------------------
Compression patches for 3.18-rc1

More fun with the LZO compression code.  Here's some patches that
properly document what the logic is, and fix up all of the previously
reported issues against the LZO code.

This has been in linux-next for a while with no issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

 Documentation/lzo.txt           | 164 ++++++++++++++++++++++++++++++++++++++++
 lib/lzo/lzo1x_decompress_safe.c | 103 ++++++++++++++-----------
 2 files changed, 221 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/lzo.txt
