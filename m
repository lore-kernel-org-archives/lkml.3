Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418Ab3DBSL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:11:57 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:14424
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759718Ab3DBSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:11:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKN3VP-02-ACA-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 0/2] cpufreq: ondemand: add AMD specific powersave bias
Date: Tue, 2 Apr 2013 13:11:42 -0500
Message-ID: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds AMD specific powersave bias function to the ondemand
governor; which can be used to help ondemand governor make more power conscious
frequency change decisions based on feedback from hardware (availble on AMD
Family 16h and above).

Hardware feedback tells software how "sensitive" to frequency changes the
workloads are. CPU-bound workloads will be more sensitive -- they will
perform better as frequency increases. Memory/IO-bound workloads will be less
sensitive -- they will not necessarily perform better as frequnecy increases.

This patchset was compared against ondemand governor without powersave bias
and did not show any performance degradation on CPU-bound workloads such as
kernbench and unixbench. While saving power on Memory-bound workloads such as
stream.

V3:
* Added to CPUID bit to cpufeature.h
* Added MODULE_DEVICE_TABLE to autoload this driver.
* Other small changes per feedback from:
  https://lkml.org/lkml/2013/4/2/349

V2:
* Added proper include files to amd_freq_sensitivity.c
* Only register powersave_bias_target function pointer and not the entire
  od_ops.

Jacob Shin (2):
  cpufreq: ondemand: allow custom powersave_bias_target handler to be
    registered
  cpufreq: AMD "frequency sensitivity feedback" powersave bias for
    ondemand governor

 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/kernel/cpu/scattered.c        |    3 +-
 drivers/cpufreq/Kconfig.x86            |   17 ++++
 drivers/cpufreq/Makefile               |    1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  150 ++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_governor.h     |    3 +
 drivers/cpufreq/cpufreq_ondemand.c     |   32 +++++--
 7 files changed, 198 insertions(+), 9 deletions(-)
 create mode 100644 drivers/cpufreq/amd_freq_sensitivity.c

-- 
1.7.9.5


