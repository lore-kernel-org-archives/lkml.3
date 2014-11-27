Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaK0IgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:36:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24671 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaK0IgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:36:21 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, linda.knippers@hp.com, viresh.kumar@linaro.org,
        rjw@rjwysocki.net, corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 0/2 V4] intel_pstate: skip this driver if hit Sun X86 servers
Date: Thu, 27 Nov 2014 17:35:30 +0900
Message-Id: <1417077332-7453-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

