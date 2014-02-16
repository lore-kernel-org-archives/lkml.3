Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBPBW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 20:22:28 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:40944 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaBPBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 20:22:26 -0500
MIME-Version: 1.0
Date: Sat, 15 Feb 2014 19:22:25 -0600
Message-ID: <CAL_JsqLu4s+r8FfdV=cT_NSQMVq_ewnf99qYw9naYrR5wg4M5Q@mail.gmail.com>
Subject: [GIT PULL] DeviceTree fixes for 3.14
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull another set of DT fixes to fix booting on some PPC boards.

Rob


The following changes since commit 860a445c25aa2f99aa5881603a1f4ed2cec64025:

  DT: Add vendor prefix for Spansion Inc. (2014-02-05 10:39:17 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/dt-fixes-for-3.14

for you to fetch changes up to 06b29e76a74b2373e6f8b5a7938b3630b9ae98b2:

  of: search the best compatible match first in __of_match_node()
(2014-02-15 18:51:17 -0600)

----------------------------------------------------------------
DeviceTree fixes for 3.14:

- Fix booting on PPC boards. Changes to of_match_node matching caused
  the serial port on some PPC boards to stop working. Reverted the
  change and reimplement to split matching between new style compatible
  only matching and fallback to old matching algorithm.

----------------------------------------------------------------
Kevin Hao (2):
      Revert "OF: base: match each node compatible against all given
matches first"
      of: search the best compatible match first in __of_match_node()

 drivers/of/base.c | 88 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 34 deletions(-)
