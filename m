Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3EZGbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:31:49 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59918 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3EZGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:31:48 -0400
Message-ID: <51A1AC4A.60506@gmail.com>
Date: Sun, 26 May 2013 14:31:38 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH v2 0/7] Remove unused /dev/oldmem interface
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/dev/oldmem provides the interface for us to access the "old memory" in
the dump-capture kernel. Unfortunately, no one actually uses this interface.

And this interface could actually cause some real problems if used on ia64
where the cached/uncached accesses are mixed. See the discussion from
the link: https://lkml.org/lkml/2013/4/12/386.

So Eric suggested that we should remove /dev/oldmem as an unused piece of
code.

Besides, we used a global variable saved_max_pfn to let the capture kernel
know the amount of memory that the previous kernel used. And for almost all
architectures (except x86. In x86, saved_max_pfn is used by detect_calgary()),
the only user of this variable is the read_oldmem interface of /dev/oldmem, so
also remove the setting for saved_max_pfn in those architectures.

-v2:
Keep /dev/oldmem and its number 12 in case this number will get reused in the
future. And mark it obsolete since /dev/oldmem will be removed from kernel.

Zhang Yanfei (7):
  /dev/oldmem: Remove this interface
  Documentation/devices.txt: Mark /dev/oldmem obsolete
  Documentation/kdump/kdump.txt: Remove /dev/oldmem description
  mips: Remove savemaxmem parameter setup
  powerpc: Remove savemaxmem parameter setup
  ia64: Remove setting for saved_max_pfn
  s390: Remove setting for saved_max_pfn

 Documentation/devices.txt        |    3 +-
 Documentation/kdump/kdump.txt    |   31 +++++--------------------
 arch/ia64/kernel/efi.c           |    5 ----
 arch/mips/kernel/crash_dump.c    |   10 --------
 arch/powerpc/kernel/crash_dump.c |   10 --------
 arch/s390/kernel/setup.c         |    4 ---
 drivers/char/mem.c               |   47 --------------------------------------
 7 files changed, 7 insertions(+), 103 deletions(-)

