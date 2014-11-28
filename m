Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaK1Ddv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 22:33:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaK1Ddt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 22:33:49 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 0/2 V4] intel_pstate: skip this driver if hit Sun X86 servers
Date: Fri, 28 Nov 2014 12:33:09 +0900
Message-Id: <1417145592-21829-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oracle Sun servers(X86) have power capping features that work via ACPI _PPC method,
patch No.1 is used to skip this driver if Oracle Sun server and _PPC detected.
Patch No.2 introduces a kernel command line parameter for those who would like
to enable intel_pstate on Sun X86 servers and be aware of the risk of no power
capping capability working and try to get better performance.

Compiled and tested with stable-3.18-rc5 on Oracle Sun server X4-2 series.

Thanks test and review by Linda Knippers <linda.knippers@hp.com>
and the suggestion,review from Dirk Brandewie <dirk.j.brandewie@intel.com>.
--
v2: fix break HP Proliant issue.
v3: expand the hardware vendor list.
v4: refine code and doc

Ethan Zhao (2):
  intel_pstate: skip this driver if Sun server has _PPC method
  intel_pstate: add kernel parameter to force loading on Sun X86
    servers.

 Documentation/kernel-parameters.txt |  5 ++++
 drivers/cpufreq/intel_pstate.c      | 49 ++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 4 deletions(-)

-- 
1.8.3.1

