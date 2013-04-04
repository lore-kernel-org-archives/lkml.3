Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3DDADS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:03:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3DDADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:03:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="35720032"
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 0/6] Hexagon: various signal and return path cleanups
Date: Wed,  3 Apr 2013 19:02:50 -0500
Message-Id: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches clean up various issues with the signal and return
path parts of the Hexagon arch port, which were pointed out by Al Viro:

https://lkml.org/lkml/2012/2/11/128

The work pending check was moved into a C routine to make it more
readable and to make sure we repeat the check when necessary.  Also, various
arguments and return values for signal handling should now be fixed.

The patches can also be viewed in the context of my next batch of cleanups
at my repo:

git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git


Any feedback is appreciated.


Thanks,
Richard Kuo




Richard Kuo (6):
  Hexagon: Signal and return path fixes
  Hexagon: fix up int enable/disable at ret_from_fork
  Hexagon: use correct work mask when checking for more work
  Hexagon: check to if we will overflow the signal stack
  Hexagon: break up user fn/arg register setting
  Hexagon: fix psp/sp macro

 arch/hexagon/include/uapi/asm/registers.h |    3 +-
 arch/hexagon/include/uapi/asm/signal.h    |    2 +
 arch/hexagon/kernel/process.c             |   44 ++++++++++++-
 arch/hexagon/kernel/signal.c              |   33 +++-------
 arch/hexagon/kernel/traps.c               |   13 +---
 arch/hexagon/kernel/vm_entry.S            |   96 +++++++++++++----------------
 6 files changed, 100 insertions(+), 91 deletions(-)

-- 
1.7.9.5


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
