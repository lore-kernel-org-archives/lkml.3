Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab3HTKDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab3HTKDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:03:12 -0400
Date: Tue, 20 Aug 2013 15:33:00 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: linux-kernel@vger.kernel.org
cc: vincent.weaver@maine.edu
Subject: About perf,arm -- oops in validate_event
Message-ID: <alpine.LFD.2.03.1308201522230.15482@erqung.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello,

  -> https://lkml.org/lkml/2013/8/7/259

I wanted to confirm if this above fix should also go into ARM64 build Or is 
ARM64 platform not vulnerable?

===
$ git diff
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 9ba33c4..cbed82f 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -317,6 +317,9 @@ validate_event(struct pmu_hw_events *hw_events,
         struct hw_perf_event fake_event = event->hw;
         struct pmu *leader_pmu = event->group_leader->pmu;

+    if (is_software_event(event))
+        return 1;
+
         if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
                 return 1;
===


Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
