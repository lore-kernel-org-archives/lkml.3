Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaFKLcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:32:32 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51217 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958AbaFKLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:32:30 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: javi.merino@arm.com, Punit Agrawal <punit.agrawal@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 0/3] Add trace to thermal framework
Date: Wed, 11 Jun 2014 12:31:41 +0100
Message-Id: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux-pm,

The linux thermal framework doesn't have any support for tracing. This
makes it hard to run workloads and observe the thermal behaviour of
the system without actively polling files in sysfs or enabling debug
builds.

This patch set introduces trace events in the framework to allow
observing the behaviour of the different components in the
framework. The events added trace temperature changes, trip points and
cooling device state changes.

The patches are based on v3.15-rc8.

Cheers,
Punit

Punit Agrawal (3):
  thermal: trace: Trace temperature changes
  thermal: trace: Trace when a cooling device's state is updated
  thermal: trace: Trace when temperature is above a trip point

 drivers/thermal/fair_share.c   |    7 +++-
 drivers/thermal/step_wise.c    |    5 ++-
 drivers/thermal/thermal_core.c |    7 ++++
 include/trace/events/thermal.h |   87 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/thermal.h

-- 
1.7.10.4

