Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaEENeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:34:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49109 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaEENeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:34:20 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <cpufreq@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] PM / OPP: move cpufreq specific helpers out of OPP layer
Date: Mon, 5 May 2014 08:33:48 -0500
Message-ID: <1399296830-13056-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq usage of OPP should be independent of the ordering of type of
data storage inside OPP layer. The current operations can equally be
performed by generic operations.

[RFC]: https://patchwork.kernel.org/patch/4100811/

Series based on: v3.15-rc1

Nishanth Menon (2):
  PM / OPP: Remove cpufreq wrapper dependency on internal data
    organization
  PM / OPP: Move cpufreq specific OPP functions out of generic OPP
    library

 Documentation/cpu-freq/core.txt |   29 +++++++++++
 Documentation/power/opp.txt     |   40 ++------------
 drivers/base/power/opp.c        |   91 --------------------------------
 drivers/cpufreq/Makefile        |    2 +
 drivers/cpufreq/cpufreq_opp.c   |  110 +++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h         |   21 ++++++++
 include/linux/pm_opp.h          |   20 -------
 7 files changed, 167 insertions(+), 146 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_opp.c

-- 
1.7.9.5

