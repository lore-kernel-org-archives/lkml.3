Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3CAQ6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:58:09 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37066 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3CAQ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:58:07 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 0/2] Add automatic bus number support for i2c busses with device tree
Date: Fri,  1 Mar 2013 08:57:30 -0800
Message-Id: <1362157052-16738-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360630085-26874-1-git-send-email-dianders@chromium.org>
References: <1360630085-26874-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was suggested by Mark Brown in response to a patch for adding
this functionality only for the s3c2410 bus:
  https://lkml.org/lkml/2012/11/20/681

I have also modified the i2c-pxa driver to use this new functionality.
The i2c-pxa driver changes have only been compile-tested and are just
for cleanup purposes.

Changes in v4:
- Rebased atop the removal of MAX_IDR_MASK.

Changes in v3:
- Addressed Wolfram's feedback; rebased atop idr-cleanup series.

Changes in v2:
- No longer tweak pdev->id as per Sylwester Nawrocki.
- No longer add the dev ID to the adap.name.  Other drivers don't
  include the device ID here and it doesn't make sense with
  dynamically (or automatically) allocated IDs.
- Use dev_name(&dev->dev) to register for the IRQ; this matches what
  the i2c-s3c2410.c does and handles dynamically allocated IDs.
- This change was only compile-tested (corgi_defconfig), since I don't
  have access to a board that uses this driver.

Doug Anderson (2):
  i2c-core: dt: Pick i2c bus number from i2c alias if present
  i2c: pxa: Use i2c-core to get bus number now

 drivers/i2c/busses/i2c-pxa.c | 20 ++++++++----------
 drivers/i2c/i2c-core.c       | 49 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 23 deletions(-)

-- 
1.8.1.3

