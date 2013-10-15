Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab3JORQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:16:58 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36163 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3JORQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:16:57 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/2] mm: Fix N_CPU handlings of node_states
Date: Tue, 15 Oct 2013 11:12:54 -0600
Message-Id: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node_stats[N_CPU] tracks which nodes have CPUs on the system.
vmstat.c updates this N_CPU information, but it has multiple
issues. 

Patch 1/2 changes setup_vmstat() to set up the N_CPU info at
boot.  Patch 2/2 changes vmstat_cpuup_callback() to udpate
the N_CPU info at CPU offline.

---
Toshi Kani (2)
  mm: Set N_CPU to node_states during boot
  mm: Clear N_CPU from node_states at CPU offline

---
 mm/vmstat.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)
