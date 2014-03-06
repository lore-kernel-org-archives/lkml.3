Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaCFGJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:09:45 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:45314 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaCFGJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:09:43 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>
Subject: [PATCH 0/4] tile: Add perf_events support for tile
Thread-Topic: [PATCH 0/4] tile: Add perf_events support for tile
Thread-Index: Ac85AqMBAg5Bl40bRgi5e0xoQOYKlQ==
Date: Thu, 6 Mar 2014 06:09:30 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FF08@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhigang Lu <zlu@tilera.com>

This patchset adds perf support for tile architecture. The code is based on x86 perf event code, and it has been tested on tile for 2 years.

Zhigang Lu (4):
  tile: Add support for handling PMC hardware
  tile: Enable NMIs on return from handle_nmi() without errors
  tile/perf: Support perf_events on tilegx and tilepro
  perf tools:  Allow building for tile

 arch/tile/Kconfig                  |    6 +
 arch/tile/include/asm/perf_event.h |   22 +
 arch/tile/include/asm/pmc.h        |   64 +++
 arch/tile/kernel/Makefile          |    2 +
 arch/tile/kernel/intvec_32.S       |   24 +-
 arch/tile/kernel/intvec_64.S       |   24 +-
 arch/tile/kernel/irq.c             |   18 +
 arch/tile/kernel/perf_event.c      | 1005 ++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/pmc.c             |  121 +++++
 tools/perf/config/Makefile.arch    |    3 +-
 tools/perf/perf.h                  |    8 +
 11 files changed, 1283 insertions(+), 14 deletions(-)
 create mode 100644 arch/tile/include/asm/perf_event.h
 create mode 100644 arch/tile/include/asm/pmc.h
 create mode 100644 arch/tile/kernel/perf_event.c
 create mode 100644 arch/tile/kernel/pmc.c

--
1.8.3.1
