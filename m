Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaG2KvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:51:19 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54118 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752849AbaG2KvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:51:18 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        javi.merino@arm.com, rui.zhang@intel.com, edubezval@gmail.com,
        rostedt@goodmis.org
Subject: [PATCH 0/3] Add trace to thermal framework
Date: Tue, 29 Jul 2014 11:50:47 +0100
Message-Id: <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux-pm,

This is the second posting of the patches to add trace to the thermal
framework.

The linux thermal framework doesn't have any support for tracing. This
makes it hard to run workloads and observe the thermal behaviour of
the system without actively polling files in sysfs or enabling debug
builds.

This patch set introduces trace events in the framework to allow
observing the behaviour of the different components in the
framework. The events added trace temperature changes, trip points and
cooling device state changes.

changes since rfc:
* Fixed an issue where incorrect trip point was traced when using fair
share
* Trace the numeric value of trip_type instead of using __print_symbolic

Punit Agrawal (3):
  thermal: trace: Trace temperature changes
  thermal: trace: Trace when a cooling device's state is updated
  thermal: trace: Trace when temperature is above a trip point

 drivers/thermal/fair_share.c   |   12 ++++++
 drivers/thermal/step_wise.c    |    5 ++-
 drivers/thermal/thermal_core.c |    7 ++++
 include/trace/events/thermal.h |   87 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/thermal.h

-- 
1.7.10.4

