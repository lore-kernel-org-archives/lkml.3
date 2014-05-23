Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaEWIuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:50:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39011 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaEWIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:50:11 -0400
Date: Fri, 23 May 2014 09:50:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2] mfd/gpio: New pull request with irq_base removed
Message-ID: <20140523085006.GN19747@lee--X1>
References: <20140520180159.3a70193c@canb.auug.org.au>
 <CACRpkdY9taDGRKj_ivkcYaHu+Jz8LnVDt-QQSntkwrcBuLitHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY9taDGRKj_ivkcYaHu+Jz8LnVDt-QQSntkwrcBuLitHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > drivers/mfd/stmpe.c: In function 'stmpe_irq_init':
> > drivers/mfd/stmpe.c:1000:15: error: 'struct stmpe' has no member named 'irq_base'
> >    base = stmpe->irq_base;
> >                ^
> >
> > Caused by commit 3ba1d516d5fe ("mfd: stmpe: root out static GPIO and
> > IRQ assignments").
> 
> Some mishap in merging these patches I think. I don't have that
> line in my branch with the latest patches,

I'm not sure that's true:

`git grep irq_base linusw-next/stmpe-for-lee -- drivers/mfd/stmpe.c`

  linusw-next/stmpe-for-lee:drivers/mfd/stmpe.c: base = stmpe->irq_base;

>I'll get the proper versions to Lee somehow.

I've fixed up the branch and re-pushed:

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-v3.16

for you to fetch changes up to 9e9dc7d9597bd6881b3e7ae6ae3d710319605c47:

  mfd: stmpe: root out static GPIO and IRQ assignments (2014-05-23 09:41:01 +0100)

----------------------------------------------------------------
Immutable branch between MFD and GPIO due for the v3.16 merge window.

----------------------------------------------------------------
Linus Walleij (4):
      mfd: stmpe: mask off unused blocks properly
      mfd: stmpe: Probe properly from the Device Tree
      mfd: stmpe: add optional regulators
      mfd: stmpe: root out static GPIO and IRQ assignments

 drivers/gpio/gpio-stmpe.c | 18 +++++-------------
 drivers/mfd/Kconfig       |  1 +
 drivers/mfd/stmpe-i2c.c   | 30 +++++++++++++++++++++++++++++-
 drivers/mfd/stmpe.c       | 33 ++++++++++++++++++++++++++++-----
 drivers/mfd/stmpe.h       |  2 +-
 include/linux/mfd/stmpe.h | 19 +++++--------------
 6 files changed, 69 insertions(+), 34 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
