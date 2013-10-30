Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3J3Um2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:42:28 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:54725 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3J3UmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:42:23 -0400
Message-ID: <52716D74.3070201@hds.com>
Date: Wed, 30 Oct 2013 16:35:00 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de,
        tglx@linutronix.de, fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v4 0/4] Introduce page fault tracepoints
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-30_06:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change from v3:
 - Separate modifications to make review easy.
 - Refactor implementations registering exception/irq_vector
   handers. (Patch 1, 2, 3)

This series introduce page fault tracepoints.

Detailed descriptions are explained in each patch.
Any comments are welcome.

Seiji Aguchi (4):
  Move set_intr_gate() into macro
  Register exception handler to trace IDT
  Delete __trace_alloc_intr_gate()
  Add page fault tracepoints

 arch/x86/include/asm/desc.h             | 57 ++++++++++++++-------------------
 arch/x86/include/asm/hw_irq.h           |  3 ++
 arch/x86/include/asm/segment.h          |  3 ++
 arch/x86/include/asm/trace/exceptions.h | 52 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h            | 20 ++++++++++++
 arch/x86/kernel/entry_32.S              | 10 ++++++
 arch/x86/kernel/entry_64.S              | 13 +++++++-
 arch/x86/kernel/head64.c                |  2 +-
 arch/x86/kernel/kvm.c                   |  2 +-
 arch/x86/kernel/traps.c                 | 28 ++++++++--------
 arch/x86/mm/Makefile                    |  2 ++
 arch/x86/mm/fault.c                     | 23 +++++++++++++
 12 files changed, 165 insertions(+), 50 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/exceptions.h

-- 
1.8.3.1

