Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab3BXRdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758762Ab3BXRdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:33:14 -0500
Date: Sun, 24 Feb 2013 18:31:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] coredump: make it freezable (almost)
Message-ID: <20130224173144.GA32179@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of coredump-sanitize-the-setting-of-signal-group_exit_code.patch

Andrew, "almost" means we need a bit more changes, but these
changes should be absolutely trivial/straightforward. We need
to add the killable/freezeng checks in dump_write/seek. But this
depends on 2/3, lets discuss this series first.

Mandeep, assuming that you agree with this series, I would be
happy if you add your sob's, this all is based on our discussion.

Oleg.

 arch/x86/ia32/ia32_aout.c |    1 -
 fs/binfmt_aout.c          |    1 -
 fs/binfmt_elf.c           |    3 +--
 fs/binfmt_elf_fdpic.c     |    2 --
 fs/coredump.c             |   13 +++++++------
 kernel/freezer.c          |    2 +-
 6 files changed, 9 insertions(+), 13 deletions(-)

