Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948Ab3DDQTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:19:11 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:39066
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762908Ab3DDQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:19:09 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKQNZQ-02-9EZ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V4 0/2] cpufreq: ondemand: add AMD specific powersave bias
Date: Thu, 4 Apr 2013 11:19:02 -0500
Message-ID: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
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

V4:
* Added proper documentation to Documentation/cpu-freq/
* Revised so that when this driver loads, the feature is enabled by
  default with a sane tunable value.

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

 Documentation/cpu-freq/governors.txt   |   21 +++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/kernel/cpu/scattered.c        |    3 +-
 drivers/cpufreq/Kconfig.x86            |   17 ++++
 drivers/cpufreq/Makefile               |    1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  148 ++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_governor.h     |    4 +
 drivers/cpufreq/cpufreq_ondemand.c     |   56 ++++++++++--
 8 files changed, 242 insertions(+), 9 deletions(-)
 create mode 100644 drivers/cpufreq/amd_freq_sensitivity.c

-- 
1.7.9.5


