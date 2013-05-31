Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3EaJyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:54:12 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36359 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab3EaJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:54:09 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: Barry Song <baohua.song@csr.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 0/2] ARM:prima2: multi_v7 kernel fixes.
Date: Fri, 31 May 2013 10:43:59 +0100
Message-Id: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

If we try to boot a multi_v7_defconfig kernel on any ARM parts other than 
prima2, you will hit kernel panics. This is because some of the code is still
using explicit early_initcall and postcore_initcalls.

Moving these calls to machine descriptor level is the right way to fix this
issue. Also the calls will not be attempted to run on any non-prima2 parts.

As I do not have any prima2 boards, I could not test these patches.
However I feel that these are safe patches.

Barry, can you give it a quick test please.

Thankyou,
srini

Srinivas Kandagatla (2):
  ARM:prima2: move sirfsoc_of_rstc_init to .init_early
  ARM:prima2:move postcore_initcalls to init_machine.

 arch/arm/mach-prima2/common.c |    6 ++++++
 arch/arm/mach-prima2/common.h |    1 +
 arch/arm/mach-prima2/pm.c     |    6 ++----
 arch/arm/mach-prima2/pm.h     |    2 ++
 arch/arm/mach-prima2/rstc.c   |    5 +----
 5 files changed, 12 insertions(+), 8 deletions(-)

-- 
1.7.6.5

