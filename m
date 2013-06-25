Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3FYOfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:35:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35194 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FYOfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:35:43 -0400
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] perf tools: Power7 events name available for perf 
Date: Tue, 25 Jun 2013 22:35:31 +0800
Message-Id: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062514-7014-0000-0000-0000033A47D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for Sukadev Bhattip and Xiao Guangrong's help.
Thank for Michael Ellerman's review. 

There is the Change Log for v2:

1. As Michael Ellerman suggested, I added runtime overhead information 
   in the 0002 patch's description.

2. Put the events name in a new head file which is named "power7-events-list.h",
   and use several macros, such as, 
 
   #define EVENT(_name, _code)     POWER_EVENT_ATTR(_name, _code)
   #include "power7-events-list.h"
   #undef EVENT
  
   to generate different outputs.
 
Thanks
Runzhen Wang

Runzhen Wang (2):
  perf tools: fix a typo of a Power7 event name
  perf tools: Make Power7 events available for perf

 .../testing/sysfs-bus-event_source-devices-events  |    2 +-
 arch/powerpc/include/asm/perf_event_server.h       |    4 +-
 arch/powerpc/perf/power7-events-list.h             |  548 ++++++++++++++++++++
 arch/powerpc/perf/power7-pmu.c                     |  150 ++----
 4 files changed, 584 insertions(+), 120 deletions(-)
 create mode 100644 arch/powerpc/perf/power7-events-list.h

-- 
1.7.9.5

