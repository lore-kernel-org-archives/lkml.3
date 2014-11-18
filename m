Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaKRI2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:28:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38321 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaKRI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:28:46 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] intel_pstate: allow to be built as module and handle Sun server power capping.
Date: Tue, 18 Nov 2014 17:27:30 +0900
Message-Id: <1416299253-14912-5-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416299253-14912-1-git-send-email-ethan.zhao@oracle.com>
References: <1416299253-14912-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Oracle Sun servers(X86) have power capping features that work via ACPI _PPC method,
patch No.1 is used to skip this driver if Oracle Sun server and _PPC detected. patch
No.2 is used to allow the driver to be configured and built as a module, so provide 
the flexibility of configuration by userland. patch No.3 introduce a module parameter
and a kernel command line parameter, let user could force it loaded even on Oracle Sun 
Servers(X86), that will be useful for debug\test\workaround etc purpose.

These patches have been tested on Oracle Sun server X4-2 series with following
cases on stable v3.18-rc3.

  a. Configure and build  intel_pstate as builtin.
     Boot without any kernel line parameter.
     Boot with intel_pstate=ignore_acpi_ppc.
  b. Configure and build intel_pstate as module.
     Load intel_pstate drive without any module parameter.
     Load intel_pstate driver with ignore_acpi_ppc=1

These cases passed and work fine.
--
Brian Maly (1):
  intel_pstate: allow driver to be built as a module

Ethan Zhao (2):
  intel_pstate: skip the driver if Sun server has ACPI _PPC method
  intel_pstate: add module and kernel command line parameter to ignore
    ACPI _PPC

 Documentation/kernel-parameters.txt |  3 +++
 drivers/cpufreq/Kconfig.x86         |  2 +-
 drivers/cpufreq/intel_pstate.c      | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

-- 
1.8.3.1

