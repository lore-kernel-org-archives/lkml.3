Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaDXMHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:07:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753188AbaDXMHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:07:45 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        eparis@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org,
        kyungsik.lee@lge.com, jslaby@suse.cz, dwight.engen@oracle.com,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 0/1] init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE documentation
Date: Thu, 24 Apr 2014 14:07:33 +0200
Message-Id: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to warn users about the negative performance
impact of CC_OPTIMIZE_FOR_SIZE (compiling with -Os instead of -O2).
For the moment, we are just advising users not to select this option,
but extra details would be useful.

I made some experiments with this option. All of them yielded
degraded overall boot time. The kernel is smaller and hence is copied
and started earlier, but the benefits are quickly offset by the
slower kernel code. Even the total boot time is usually worse
than with a regular kernel.

Here are my latest results, on Atmel SAMA5D3 Xplained (ARM),
Linux 3.10, gzip compressed kernel:

Timestamp		O2		Os		Diff
Starting kernel 	4.307 s 	5.593 s 	-94 ms
Starting init		4.213 s 	5.549 s 	-44 ms
Login prompt		21.085 s	22.900 s 	+1.815 s 

Michael Opdenacker (1):
  init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE documentation

 init/Kconfig | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
1.8.3.2

