Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3KYXXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:23:08 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:60812 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab3KYXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:23:02 -0500
To: mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        felipe.contreras@gmail.com, linux-kernel@vger.kernel.org
Message-Id: <cover.1385418410.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/3 v3] build in panic_timeout value
Date: Mon, 25 Nov 2013 23:23:00 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've now separated out the arch bits into separate patches. Hopefully, it makes
review easier. I also didn't address moving the 'panic_timeout' command-line
parameter up as an 'early_param()'. I think it might make sense to move it up,
especially for distro kernels, but its not a need here, so I didn't want to just
shove it in. If needed, I think it can come in separately, as it shoudn't
affect this series.

Thanks,

-Jason 


v3:
 -separate arch bits
 -drop mips settings of panic_timeout as per Ralf Baechle

v2:
 -restrict arch defaults to arch/ code
 -add set_arch_panic_timeout(), in case .config specifies a non-default timeout

Jason Baron (2):
  panic: Make panic_timeout configurable
  powerpc: cleanup panic_timeout

Ralf Baechle (1):
  mips: remove panic_timeout settings.

 arch/mips/ar7/setup.c                  | 1 -
 arch/mips/emma/markeins/setup.c        | 3 ---
 arch/mips/netlogic/xlp/setup.c         | 1 -
 arch/mips/netlogic/xlr/setup.c         | 1 -
 arch/mips/sibyte/swarm/setup.c         | 2 --
 arch/powerpc/Kconfig                   | 4 ++++
 arch/powerpc/include/asm/setup.h       | 1 +
 arch/powerpc/kernel/setup_32.c         | 3 ---
 arch/powerpc/kernel/setup_64.c         | 3 ---
 arch/powerpc/platforms/pseries/setup.c | 2 +-
 include/linux/kernel.h                 | 9 +++++++++
 kernel/panic.c                         | 2 +-
 lib/Kconfig.debug                      | 9 +++++++++
 13 files changed, 25 insertions(+), 16 deletions(-)

-- 
1.8.2

