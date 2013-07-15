Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3GOW2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:28:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36961 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3GOW2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:28:37 -0400
Date: Mon, 15 Jul 2013 23:27:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
Message-ID: <20130715222755.GY24642@n2100.arm.linux.org.uk>
References: <201307051738.35930.arnd@arndb.de> <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:16:12PM -0700, Andrew Morton wrote:
> I've been thinking for a while that CONFIG_BUG=n is a pretty dumb thing
> to do, and that maintaining it (and trying to fix the warnings it
> produces) aren't worth the effort and that we should remove the whole
> thing.  Perhaps your patch changes that calculus, dunno.  Please discuss.

This isn't about introducing "CONFIG_BUG=n" - this is about making a
kernel with CONFIG_BUG=n build without producing tonnes and tonnes of
warnings, as it does today.  It makes building randconfig pretty
useless to find what could be more important warnings.

For example, this is a small extract from one such build log that
randconfig decided to set CONFIG_BUG to n:

fs/ext4/extents.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/ext4_jbd2.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/mballoc.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/move_extent.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/indirect.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/inline.c: In function 'ext4_inode_journal_mode':
fs/ext4/ext4_jbd2.h:415:1: warning: control reaches end of non-void function
fs/ext4/acl.c: In function 'acl_by_type':
include/linux/posix_acl.h:108:1: warning: control reaches end of non-void function
fs/ext4/acl.c: In function 'ext4_get_acl':
fs/ext4/acl.c:150:6: warning: 'name_index' may be used uninitialized in this funtion
