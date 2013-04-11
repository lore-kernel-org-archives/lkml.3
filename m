Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755Ab3DKVaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:30:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56523 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab3DKVaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:30:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] Power management fixes for v3.9-rc7
Date: Thu, 11 Apr 2013 23:38:03 +0200
Message-ID: <1717944.2nHtn633sQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-3.9-rc7

to receive power management fixes for v3.9-rc7 with top-most commit
6f389a8f1dd22a24f3d9afc2812b30d639e94625

  PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

on top of commit 31880c37c11e28cb81c70757e38392b42e695dc6

  Linux 3.9-rc6

Included are:

- System reboot/halt fix that prevents some systems from crashing
  during reboot due to a violation of ordering between
  syscore_shutdown() and disable_nonboot_cpus().  From Huacai Chen.

- intel_pstate driver fix for a delay time calculation mistake
  that causes systems using the driver to crash occasionally in a
  hard to reproduce way.  From Dirk Brandewie.

Thanks!

---------------

Dirk Brandewie (1):
      cpufreq / intel_pstate: Set timer timeout correctly

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

---------------

 drivers/cpufreq/intel_pstate.c |    1 -
 kernel/sys.c                   |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

