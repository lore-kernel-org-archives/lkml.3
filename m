Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3LWAKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 19:10:09 -0500
Received: from ozlabs.org ([203.10.76.45]:41451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab3LWAKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 19:10:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PULL] fixes for virtio balloon and non-MMU kallsyms
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 23 Dec 2013 10:37:54 +1030
Message-ID: <87r494l99h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit af91706d5ddecb4a9858cca9e90d463037cfd498:

  ima: store address of template_fmt_copy in a pointer before calling strsep (2013-11-30 13:09:53 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to 7122c3e9154b5d9a7422f68f02d8acf050fad2b0:

  scripts/link-vmlinux.sh: only filter kernel symbols for arm (2013-12-10 16:49:19 +1030)

----------------------------------------------------------------
Refactoring broke the balloon driver, and fixing kallsyms on ARM broke
some (non-ARM) MMUless setups, so we're making that fix ARM-only for now.

Unfortunately, the ARM refactoring which broke kallsyms/perf was CC:stable,
so the fix (which broken non-ARM) was also CC:stable, so now the partial
reversion is also CC:stable...

Cheers,
Rusty.

----------------------------------------------------------------
Luiz Capitulino (1):
      virtio_balloon: update_balloon_size(): update correct field

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

 drivers/virtio/virtio_balloon.c | 2 +-
 scripts/link-vmlinux.sh         | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)
