Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3C0Wha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:37:30 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:18572
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571Ab3C0Wh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:37:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCC6A-01-3T8-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/2] cpufreq: ondemand: add AMD specific powersave bias
Date: Wed, 27 Mar 2013 17:37:19 -0500
Message-ID: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
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

This applies to linux-pm's linux-next branch, on top of Viresh's 'Implement
per policy instance of governor' V4 patchset:

https://lkml.org/lkml/2013/3/27/348

Jacob Shin (2):
  cpufreq: ondemand: allow custom od_ops to be registered
  cpufreq: AMD "frequency sensitivity feedback" powersave bias for
    ondemand governor

 arch/x86/include/uapi/asm/msr-index.h |    1 +
 drivers/cpufreq/Kconfig.x86           |   10 ++++++++++
 drivers/cpufreq/Makefile              |    1 +
 drivers/cpufreq/cpufreq_governor.h    |    2 ++
 drivers/cpufreq/cpufreq_ondemand.c    |   32 +++++++++++++++++++++++++++-----
 5 files changed, 41 insertions(+), 5 deletions(-)

-- 
1.7.9.5


