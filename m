Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaDWLhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:37:10 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57659 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaDWLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:37:01 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, kefeng.wang@linaro.org
Subject: [PATCH v4 0/3] ahci: add support for hisilicon sata
Date: Wed, 23 Apr 2014 19:36:44 +0800
Message-Id: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes in v4:

1) add a dynamic host_flags parameter in ahci_platform_init_host
   to make it more flexible, modify some driver to use new
   way to pass host flags, suggested by Hans

changes in v3:

1) move NO_FBS chunk after YES_FBS, Tejun's suggestion
2) use ata_port_info pointer to avoid struct ata_port_info
   on the stack twice

changes in v2:

1) make code more concise according to Hans's advice



Kefeng Wang (3):
  ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
  libahci_platform: add host_flags parameter in
    ahci_platform_init_host()
  ahci: add support for Hisilicon sata

 .../devicetree/bindings/ata/ahci-platform.txt      |    3 ++-
 drivers/ata/ahci.h                                 |    1 +
 drivers/ata/ahci_da850.c                           |    3 ++-
 drivers/ata/ahci_imx.c                             |    3 ++-
 drivers/ata/ahci_platform.c                        |    8 +++++++-
 drivers/ata/ahci_st.c                              |    2 +-
 drivers/ata/ahci_sunxi.c                           |    9 ++++++---
 drivers/ata/ahci_xgene.c                           |    6 +++++-
 drivers/ata/libahci.c                              |    5 +++++
 drivers/ata/libahci_platform.c                     |    2 ++
 include/linux/ahci_platform.h                      |    1 +
 11 files changed, 34 insertions(+), 9 deletions(-)

-- 
1.7.9.5

