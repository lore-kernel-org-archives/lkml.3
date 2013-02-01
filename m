Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3BAJYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:24:41 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:45936 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3BAJYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:24:39 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 1 Feb 2013 10:24:38 +0100
Message-ID: <CA+icZUVR1MYTBfrLy2-WiXPjn6f7FYdkyDPrjPbEXo1SDjH8Yg@mail.gmail.com>
Subject: [3.8-rcX] <file:Documentation/lockdep-design.txt> up2date?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is lockdep-design.txt up2date with Linux v3.8-rcX?

I have here in my kernel-config:

$ grep \_LOCK /boot/config-$(uname -r)
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_I8253_LOCK=y
CONFIG_FILE_LOCKING=y
CONFIG_LOCKUP_DETECTOR=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set

Do I need to enable more config-options (one or more of the above) to see...

 271         grep "lock-classes" /proc/lockdep_stats

 281         grep "BD" /proc/lockdep

I have none of these files, but...

$ cat /proc/locks
1: POSIX  ADVISORY  READ  8139 07:00:395776 128 128
2: POSIX  ADVISORY  READ  8139 07:00:396862 1073741826 1073742335
3: POSIX  ADVISORY  READ  8139 07:00:393673 128 128
4: POSIX  ADVISORY  READ  8139 07:00:409154 1073741826 1073742335
5: POSIX  ADVISORY  WRITE 8139 07:00:409114 0 EOF
6: POSIX  ADVISORY  WRITE 6757 07:00:409055 0 0
7: POSIX  ADVISORY  READ  6755 07:00:409053 128 128
8: POSIX  ADVISORY  READ  6755 07:00:409051 1073741826 1073742335
9: POSIX  ADVISORY  READ  6749 07:00:409053 128 128
10: POSIX  ADVISORY  READ  6749 07:00:409051 1073741826 1073742335
11: POSIX  ADVISORY  WRITE 1163 00:0f:8077 0 EOF
12: FLOCK  ADVISORY  WRITE 1137 00:0f:8060 0 EOF

BTW, "config LOCKDEP" has no help-text and no pointer to
Documentation/lockdep-design.txt (assuming this is the correct
reference to LOCKDEP stuff).
See also my posting in [2].
Furthermore, lockdep-design.txt says no word to kernel-config options
(which one to enable - in case of debug/verbosity++?)!

If this is all correct, can you update the docs, please!?

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/lockdep-design.txt
[2] http://marc.info/?l=linux-kernel&m=135970976716034&w=2
