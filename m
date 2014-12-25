Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaLYJ2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:28:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaLYJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:28:40 -0500
Date: Thu, 25 Dec 2014 11:28:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH repost 00/16] uaccess: fix sparse warning on get_user for
 bitwise types
Message-ID: <1419499661-8566-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Arnd's request, reposting now that 3.19-rc1 is out.
No changes from the original post, except that xtensa
and powerpc patches have been merged by maintainers.
Please review, and consider for 3.20.

At the moment, if p and x are both tagged as bitwise types,
get_user(x, p) produces a sparse warning on many architectures.
This is because *p on these architectures is loaded into long
(typically using asm), then cast back to typeof(*p).

When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
__force, otherwise sparse produces a warning.

Some architectures already have the __force tag, add it
where it's missing.

Specificlly, vhost wants to read bitwise types from userspace using get_user.
At the moment this triggers sparse errors, since the value is passed through an
integer.

I tested this on x86 only. Since it's just adding __force, should be
trivially safe everywhere?


Michael S. Tsirkin (16):
  x86/uaccess: fix sparse errors
  alpha/uaccess: fix sparse errors
  arm64/uaccess: fix sparse errors
  avr32/uaccess: fix sparse errors
  blackfin/uaccess: fix sparse errors
  cris/uaccess: fix sparse errors
  ia64/uaccess: fix sparse errors
  m32r/uaccess: fix sparse errors
  metag/uaccess: fix sparse errors
  microblaze/uaccess: fix sparse errors
  openrisc/uaccess: fix sparse errors
  parisc/uaccess: fix sparse errors
  sh/uaccess: fix sparse errors
  sparc/uaccess: fix sparse errors
  sparc/uaccess: fix sparse errors
  m68k/uaccess: fix sparse errors

 arch/alpha/include/asm/uaccess.h      | 4 ++--
 arch/arm64/include/asm/uaccess.h      | 2 +-
 arch/avr32/include/asm/uaccess.h      | 4 ++--
 arch/blackfin/include/asm/uaccess.h   | 2 +-
 arch/cris/include/asm/uaccess.h       | 4 ++--
 arch/ia64/include/asm/uaccess.h       | 2 +-
 arch/m32r/include/asm/uaccess.h       | 4 ++--
 arch/m68k/include/asm/uaccess_mm.h    | 4 ++--
 arch/metag/include/asm/uaccess.h      | 4 ++--
 arch/microblaze/include/asm/uaccess.h | 4 ++--
 arch/openrisc/include/asm/uaccess.h   | 4 ++--
 arch/parisc/include/asm/uaccess.h     | 2 +-
 arch/sh/include/asm/uaccess.h         | 4 ++--
 arch/sparc/include/asm/uaccess_32.h   | 8 ++++----
 arch/sparc/include/asm/uaccess_64.h   | 4 ++--
 arch/x86/include/asm/uaccess.h        | 2 +-
 16 files changed, 29 insertions(+), 29 deletions(-)

-- 
MST

