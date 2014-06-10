Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaFJJwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:52:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45978 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaFJJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:52:39 -0400
Message-ID: <5396D529.308@linaro.org>
Date: Tue, 10 Jun 2014 17:51:37 +0800
From: "kefeng.wang" <kefeng.wang@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
        xuwei5@hisilicon.com
Subject: [PATCH] ahci: disable ncq feature for hisilicon sata
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org> <20140514170757.GD15690@htj.dyndns.org>
In-Reply-To: <20140514170757.GD15690@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NCQ feature is unsupported on hisilicon sata controller, so disable it.
This version of IP is used by hip04 and hix5hd2 soc.

Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 drivers/ata/ahci_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ebe505c..0cfda8b 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -58,7 +58,7 @@ static int ahci_probe(struct platform_device *pdev)
        }

        if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
-               hflags |= AHCI_HFLAG_NO_FBS;
+               hflags = AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;

        rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
                                     hflags, 0, 0);
-- 
1.7.9.5
