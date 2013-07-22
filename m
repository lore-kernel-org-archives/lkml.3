Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3GVCZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 22:25:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:12508 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3GVCZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 22:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,715,1367996400"; 
   d="scan'208";a="349369251"
Message-ID: <1374459939.2057.44.camel@rzhang1-mobl4>
Subject: [GIT PULL] Thermal  management fixes for v3.11-rc3
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Mon, 22 Jul 2013 10:25:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive Thermal management fixes for v3.11-rc3 with
top-most commit ace120dcf23b3bbba00d797a898481997381052f:

  Thermal: Fix lockup of cpu_down()

on top of commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4

These are fixes collected over the last week, they fixes several
problems caused by the x86_pkg_temp_thermal introduced in 3.11-rc1.

Specifics:

- the x86_pkg_temp_thermal driver causes crash on systems with no
  package MSR support as there is a bug in the logic to check presence
  of DTHERM and PTS feature together. Added a change so that when there
  is no PTS support, module doesn't get loaded.

- fix krealloc() misuse in pkg_temp_thermal_device_add().
  If krealloc() returns NULL, it doesn't free the original. Thus if we
  want to exit because of the krealloc() failure, we must make sure the
  original one is freed.
 
- The error code path of the x86 package temperature thermal driver's
  initialization routine makes an unbalanced call to get_online_cpus(),
  which causes subsequent CPU offline operations, and consequently
  system suspend, to permanently block in cpu_hotplug_begin() on systems
  where get_core_online() returns an error code.
  Remove the extra get_online_cpus() to fix the problem.

Thanks!

----------------------------------------------------------------
Srinivas Pandruvada (2):
      Thermal: x86 package temp thermal crash
      Thermal: x86_pkg_temp: Limit number of pkg temp zones

Steven Rostedt (1):
      Thermal: Fix lockup of cpu_down()

Wei Yongjun (1):
      Thermal: x86_pkg_temp: fix krealloc() misuse in in
pkg_temp_thermal_device_add()

 drivers/thermal/x86_pkg_temp_thermal.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)


