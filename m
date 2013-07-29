Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3G2W45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:56:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39138 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3G2W4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:56:55 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 0/7] Cpufreq, cpu hotplug, suspend/resume related fixes
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 04:23:12 +0530
Message-ID: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072922-9574-0000-0000-000008F0E08F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patchset reorganizes the cpufreq code and preserves the file permissions
of cpufreq-related per-cpu sysfs files across suspend/resume cycles, by
performing a light-weight init/teardown in those paths.

Patches 1 - 4 reorganize the code and have no functional impact, and can go
in as general cleanups as well. This reorganization builds a base that the
rest of the patches will make use of.

Patch 5 and 6 add a mechanism to perform light-weight init/tear-down of CPUs
in the cpufreq subsystem and finally patch 7 uses it to preserve sysfs files
across suspend/resume.

All the patches apply on Rafael's bleeding-edge branch on linux-pm git
tree[1].


Changes in v2:
* Fixed a refcounting bug explained here:
  http://marc.info/?l=linux-kernel&m=137511192600806&w=2

* Addressed some suggestions about code reorganization received in v1.
* Rebased on top of the bleeding-edge branch.


[1]. git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git bleeding-edge

Thank you very much!


 Srivatsa S. Bhat (7):
      cpufreq: Fix misplaced call to cpufreq_update_policy()
      cpufreq: Add helper to perform alloc/free of policy structure
      cpufreq: Extract non-interface related stuff from cpufreq_add_dev_interface
      cpufreq: Extract the handover of policy cpu to a helper function
      cpufreq: Introduce a flag ('frozen') to separate full vs temporary init/teardown
      cpufreq: Preserve policy structure across suspend/resume
      cpufreq: Perform light-weight init/teardown during suspend/resume


 drivers/cpufreq/cpufreq.c       |  303 ++++++++++++++++++++++++++-------------
 drivers/cpufreq/cpufreq_stats.c |    8 -
 2 files changed, 205 insertions(+), 106 deletions(-)


Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

