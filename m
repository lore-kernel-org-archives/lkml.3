Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaDGSnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:43:20 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37610 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaDGSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:43:17 -0400
Message-ID: <5342F1E8.10803@linaro.org>
Date: Mon, 07 Apr 2014 13:43:52 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matt Porter <matt.porter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
Subject: [GIT PULL] clk: bcm281xx: urgent fix for older compilers
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, I learned this morning that my clock code (now in
Linus Torvald's master branch) uses a feature that is not
supported in older versions of gcc.  Specifically, the
code made use of unnamed struct and union fields, e.g.:

    struct foo {
	u64	bar;
	union {
	    u32	    baz;
	    bool    quux;
	};
    };

I've prepared a patch that resolves this.  Would you please
pull this critical fix for 3.15-rc1 and get it to Linus as
soon as possible?  Thank you.

					-Alex

The following changes since commit 18a1a7a1d862ae0794a0179473d08a414dd49234:

  Merge
git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
(2014-04-06 08:11:57 -0700)

are available in the git repository at:


  git://git.linaro.org/landing-teams/working/broadcom/kernel.git
pull/urgent-for-mturquette

for you to fetch changes up to a7a7eba0eeff8f839cde4b327b56dc057a1a48d7:

  clk: bcm281xx: don't use unnamed structs or unions (2014-04-07
13:29:34 -0500)

----------------------------------------------------------------
Alex Elder (1):
      clk: bcm281xx: don't use unnamed structs or unions

 drivers/clk/bcm/clk-kona-setup.c |   33 ++++++++++----------
 drivers/clk/bcm/clk-kona.c       |   64
++++++++++++++++++++------------------
 drivers/clk/bcm/clk-kona.h       |   28 ++++++++---------
 3 files changed, 64 insertions(+), 61 deletions(-)
