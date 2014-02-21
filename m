Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaBUWMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:12:09 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65202 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaBUWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:12:06 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 21 Feb 2014 22:11:45 +0000
X-Google-Sender-Auth: l0oVJfiSgpprQ2P3AuvQmymQX9s
Message-ID: <CACxGe6t=Aij59zHGzD2ZbEGeUALx1t=-KXKcfDPYFoQd_FnLeQ@mail.gmail.com>
Subject: [GIT PULL] Device tree bug fix on compatible order
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following tag for a devicetree bug fix (description below)

Thanks,
g.

The following changes since commit 60f76eab19e3903e810bdc3ec846c158efcd2e21:

  Merge tag 'dma-buf-for-3.14' of
git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf
(2014-02-17 12:42:45 -0800)

are available in the git repository at:


  git://git.secretlab.ca/git/linux tags/dt-for-linus

for you to fetch changes up to 1f42e5dd5065963979bb53daadf5d4f1e71f0c5f:

  of: Add self test for of_match_node() (2014-02-20 11:52:09 +0000)

----------------------------------------------------------------
Device tree compatible match order bug fix

This branch contains a bug fix for the way devicetree code identifies
the type of device. Device drivers can contain a list of of_device_ids,
but it more than one entry will match, then the device driver may choose
the wrong one. Commit 105353145e, "match each node compatible against
all given matches first", was queued for v3.14 but ended up causing
other bugs. Commit 06b29e76a7 attempted to fix it but it had other bugs.
Merely reverting the fix and waiting until v3.15 isn't a good option
because there is code in v3.14 that depends on the revised behaviour to
boot.

This branch should finally fixes the problem correctly. This time
instead of just hoping that the patch is correct, this branch also adds
new testcases that validate the behaviour.

The changes in this branch are larger than I would like for a -rc pull,
but moving the test case data out of out of arch/arm so that it could be
validated on other architectures was important.

----------------------------------------------------------------
Grant Likely (2):
      of: Move testcase FDT data into drivers/of
      of: Add self test for of_match_node()

Kevin Hao (2):
      Revert "of: search the best compatible match first in __of_match_node()"
      of: reimplement the matching method for __of_match_node()

 arch/arm/boot/dts/testcases/tests.dtsi             |   2 -
 arch/arm/boot/dts/versatile-pb.dts                 |   4 +-
 drivers/of/base.c                                  | 150 ++++++++++-----------
 drivers/of/selftest.c                              |  67 +++++++++
 drivers/of/testcase-data/testcases.dtsi            |   3 +
 .../of/testcase-data}/tests-interrupts.dtsi        |   0
 drivers/of/testcase-data/tests-match.dtsi          |  19 +++
 .../of/testcase-data}/tests-phandle.dtsi           |   0
 scripts/Makefile.lib                               |   1 +
 9 files changed, 166 insertions(+), 80 deletions(-)
 delete mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/of/testcase-data/testcases.dtsi
 rename {arch/arm/boot/dts/testcases =>
drivers/of/testcase-data}/tests-interrupts.dtsi (100%)
 create mode 100644 drivers/of/testcase-data/tests-match.dtsi
 rename {arch/arm/boot/dts/testcases =>
drivers/of/testcase-data}/tests-phandle.dtsi (100%)
