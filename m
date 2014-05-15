Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaEONZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaEONZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:25:12 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/2 v2] x86, Fix irq exhaustion issues with cpu hotplug
Date: Thu, 15 May 2014 09:25:03 -0400
Message-Id: <1400160305-17774-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches have been previously submitted but appear to have been lost
on LKML.

There are still some issues with irq exhaustion when removing cpus.  These
two patches fix two serious bugs.  The first patch, from Yinghai Lu, corrects
the available vectors count for each cpu.  The second patch takes into account
the numa-awareness of an irq when reassigning the irq.

Prarit Bhargava (1):
  x86, make check_irq_vectors_for_cpu_disable() aware of numa node irqs

Yinghai Lu (1):
  x86, irq: get correct available vectors for cpu disable

 arch/x86/kernel/irq.c |  158 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 116 insertions(+), 42 deletions(-)

-- 
1.7.9.3

