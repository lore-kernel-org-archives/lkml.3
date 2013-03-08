Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341Ab3CHPkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:40:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:41910 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934260Ab3CHPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:40:45 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        mturquette@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        rob.herring@calxeda.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] sta2x11 common clock framework implementation
Date: Fri,  8 Mar 2013 16:31:28 +0100
Message-Id: <1362756691-14736-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset is the first implementation of the common clock framework for
the STA2X11 (aka connext) chip.

Actually 1/3 and 2/3 are not strictly relevant to the clock framework, but
they're needed to get the rest of the code to compile and have already
been submitted some months ago (see https://lkml.org/lkml/2012/9/20/363)
and acked by Alessandro Rubini (see https://lkml.org/lkml/2012/9/20/452).

3/3 has been submitted RFC on Jun 20th 2012
(see https://lkml.org/lkml/2012/6/20/779).
Mike Turquette reviewed it (see https://lkml.org/lkml/2012/8/23/624) and
his comments have been taken into account for this submission.

Please note that this patchset applies to next-20130307, should build cleanly
and do no harm at runtime, but it is not functional because it needs the
pci-to-amba bridge patch by Alessandro Rubini, which has already been
submitted several times but has not made it in the linux-next tree
yet (see thread https://lkml.org/lkml/2013/2/20/561 for more details).

Some clocks still have to be added and some others need to be implemented
with different types (see the TODOs in the code), but the current
implementation is actually enough to get a Connext based board up and running
(with its UARTs working at least), of course provided that the pci to
amba bridge is there. Multiple instances of the Connext chip should also be
supported, even if no test has been done up to now.

Thanks and regards
Davide


Davide Ciminaghi (3):
  x86, pci sta2x11-fixup: add clk related field to struct
    sta2x11_instance
  x86, pci sta2x11-fixup: add function to access sta2x11 instance id
  drivers/clk: sta2x11 common clock framework implementation

 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/sta2x11.h      |   16 +
 arch/x86/pci/sta2x11-fixup.c        |   20 +
 drivers/clk/Makefile                |    1 +
 drivers/clk/sta2x11/Makefile        |    1 +
 drivers/clk/sta2x11/clk-audio-pll.c |  150 +++++++
 drivers/clk/sta2x11/clk-soc-pll.c   |   96 +++++
 drivers/clk/sta2x11/clk.c           |  782 +++++++++++++++++++++++++++++++++++
 drivers/clk/sta2x11/clk.h           |   73 ++++
 9 files changed, 1140 insertions(+)
 create mode 100644 drivers/clk/sta2x11/Makefile
 create mode 100644 drivers/clk/sta2x11/clk-audio-pll.c
 create mode 100644 drivers/clk/sta2x11/clk-soc-pll.c
 create mode 100644 drivers/clk/sta2x11/clk.c
 create mode 100644 drivers/clk/sta2x11/clk.h

-- 
1.7.10.4

