Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab3DHKAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:00:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964865Ab3DHKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:00:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,431,1363104000"; 
   d="scan'208";a="7014990"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: cl@linux.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arnd@arndb.de, tony@atomide.com, ben@decadent.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 0/2] mm: vmemmap: add vmemmap_verify check for hot-add node/memory case
Date: Mon, 8 Apr 2013 17:56:38 +0800
Message-Id: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:53:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:54:15,
	Serialize complete at 2013/04/08 17:54:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hot add node(memory) case, vmemmap pages are always allocated from other
node, but the current logic just skip vmemmap_verify check. 
So we should also issue "potential offnode page_structs" warning messages
if we are the case

Lin Feng (2):
  mm: vmemmap: x86: add vmemmap_verify check for hot-add node case
  mm: vmemmap: arm64: add vmemmap_verify check for hot-add node case

 arch/arm64/mm/mmu.c   | 4 ++--
 arch/x86/mm/init_64.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
1.8.0.1

