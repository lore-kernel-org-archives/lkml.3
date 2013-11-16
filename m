Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KPNkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 08:40:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3KPNj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 08:39:29 -0500
From: Thomas Renninger <trenn@suse.de>
To: rjw@sisk.pl
Cc: trenn@suse.de, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Yanmin Zhang <yanmin_zhang@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>, cl@linux.com
Subject: [PATCH 1/2] tools cpupower: Add cpupower-idle-set(1) manpage
Date: Sat, 16 Nov 2013 14:39:21 +0100
Message-Id: <1384609162-77010-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1384609162-77010-1-git-send-email-trenn@suse.de>
References: <1384609162-77010-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpupower idle-set subcommand was introduce recently.
This patch provides the missing manpage.

If cpupower is properly installed it will show up automatically (similar to
git), when invoking:
cpupower help idle-set
or
cpupower idle-set --help

Some parts have been taken over and adjusted from
git commit 62d6ae880e3e76098
documentation submitted by Carsten Emde.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Carsten Emde <C.Emde@osadl.org>
CC: Yanmin Zhang <yanmin_zhang@intel.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: ShuoX Liu <shuox.liu@intel.com>
CC: cl@linux.com
---
 tools/power/cpupower/man/cpupower-idle-info.1 |    3 +-
 tools/power/cpupower/man/cpupower-idle-set.1  |   71 +++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletions(-)
 create mode 100644 tools/power/cpupower/man/cpupower-idle-set.1

diff --git a/tools/power/cpupower/man/cpupower-idle-info.1 b/tools/power/cpupower/man/cpupower-idle-info.1
index 4178eff..7b3646a 100644
--- a/tools/power/cpupower/man/cpupower-idle-info.1
+++ b/tools/power/cpupower/man/cpupower-idle-info.1
@@ -87,4 +87,5 @@ Thomas Renninger <trenn@suse.de>
 .fi
 .SH "SEE ALSO"
 .LP
-cpupower(1), cpupower\-monitor(1), cpupower\-info(1), cpupower\-set(1)
+cpupower(1), cpupower\-monitor(1), cpupower\-info(1), cpupower\-set(1),
+cpupower\-idle\-set(1)
diff --git a/tools/power/cpupower/man/cpupower-idle-set.1 b/tools/power/cpupower/man/cpupower-idle-set.1
new file mode 100644
index 0000000..6b16072
--- /dev/null
+++ b/tools/power/cpupower/man/cpupower-idle-set.1
@@ -0,0 +1,71 @@
+.TH "CPUPOWER-IDLE-SET" "1" "0.1" "" "cpupower Manual"
+.SH "NAME"
+.LP
+cpupower idle\-set \- Utility to set cpu idle state specific kernel options
+.SH "SYNTAX"
+.LP
+cpupower [ \-c cpulist ] idle\-info [\fIoptions\fP]
+.SH "DESCRIPTION"
+.LP
+The cpupower idle\-set subcommand allows to set cpu idle, also called cpu
+sleep state, specific options offered by the kernel. One example is disabling
+sleep states. This can be handy for power vs performance tuning.
+.SH "OPTIONS"
+.LP
+.TP
+\fB\-d\fR \fB\-\-disable\fR
+Disable a specific processor sleep state.
+.TP
+\fB\-e\fR \fB\-\-enable\fR
+Enable a specific processor sleep state.
+
+.SH "REMARKS"
+.LP
+Cpuidle Governors Policy on Disabling Sleep States
+
+.RS 4
+Depending on the used  cpuidle governor, implementing the kernel policy
+how to choose sleep states, subsequent sleep states on this core, might get
+disabled as well.
+
+There are two cpuidle governors ladder and menu. While the ladder
+governor is always available, if CONFIG_CPU_IDLE is selected, the
+menu governor additionally requires CONFIG_NO_HZ.
+
+The behavior and the effect of the disable variable depends on the
+implementation of a particular governor. In the ladder governor, for
+example, it is not coherent, i.e. if one is disabling a light state,
+then all deeper states are disabled as well. Likewise, if one enables a
+deep state but a lighter state still is disabled, then this has no effect.
+.RE
+.LP
+Disabling the Lightest Sleep State may not have any Affect
+
+.RS 4
+If criteria are not met to enter deeper sleep states and the lightest sleep
+state is chosen when idle, the kernel may still enter this sleep state,
+irrespective of whether it is disabled or not. This is also reflected in
+the usage count of the disabled sleep state when using the cpupower idle-info
+command.
+.RE
+.LP
+Selecting specific CPU Cores
+
+.RS 4
+By default processor sleep states of all CPU cores are set. Please refer
+to the cpupower(1) manpage in the \-\-cpu option section how to disable
+C-states of specific cores.
+.RE
+.SH "FILES"
+.nf
+\fI/sys/devices/system/cpu/cpu*/cpuidle/state*\fP
+\fI/sys/devices/system/cpu/cpuidle/*\fP
+.fi
+.SH "AUTHORS"
+.nf
+Thomas Renninger <trenn@suse.de>
+.fi
+.SH "SEE ALSO"
+.LP
+cpupower(1), cpupower\-monitor(1), cpupower\-info(1), cpupower\-set(1),
+cpupower\-idle\-info(1)
-- 
1.7.6.1

