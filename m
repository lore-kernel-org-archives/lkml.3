Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3JYNDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:03:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47230 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3JYNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:03:48 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Salter <msalter@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the c6x tree
Date: Fri, 25 Oct 2013 15:03:39 +0200
Message-Id: <1382706224-8859-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382632289-18523-1-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the c6x tree got a conflict in

	arch/arm/Kconfig

caused by commits 148104c (ARM: 7854/1: lockref: add support for lockless
lockrefs using cmpxchg64) and commit d701884 (arm: select
ARCH_MIGHT_HAVE_PC_PARPORT).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc arch/arm/Kconfig
index c06647d,7db8abe0..b6a708e
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -5,7 -5,7 +5,8 @@@ config AR
  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
  	select ARCH_HAVE_CUSTOM_GPIO_H
 +	select ARCH_USE_CMPXCHG_LOCKREF
+ 	select ARCH_MIGHT_HAVE_PC_PARPORT
  	select ARCH_WANT_IPC_PARSE_VERSION
  	select BUILDTIME_EXTABLE_SORT if MMU
  	select CLONE_BACKWARDS
