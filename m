Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaEBPXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:23:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaEBPXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:23:10 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Alan Cox <alan@linux.intel.com>, Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] [linux-next] pwm: lpss: fix const qualifier discard warning
Date: Fri,  2 May 2014 17:22:59 +0200
Message-Id: <1399044179-17912-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing this warning:
drivers/pwm/pwm-lpss.c: In function ‘pwm_lpss_probe_pci’:
drivers/pwm/pwm-lpss.c:192:2: warning: passing argument 3 of ‘pwm_lpss_probe’ discards ‘const’ qualifier from pointer target type [enabled by default]
  lpwm = pwm_lpss_probe(&pdev->dev, &pdev->resource[0], info);
  ^
drivers/pwm/pwm-lpss.c:130:30: note: expected ‘struct pwm_lpss_boardinfo *’ but argument is of type ‘const struct pwm_lpss_boardinfo *’
 static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,

That warning was introduced in commit 093e00bb3f82f3c67e2d1682e316fc012bcd0d92
("pwm: lpss: Add support for PCI devices").

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/pwm/pwm-lpss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index c718ad1..c4620c1 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -129,6 +129,7 @@ static const struct pwm_ops pwm_lpss_ops = {
 
 static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
 					    struct resource *r,
+					    const
 					    struct pwm_lpss_boardinfo *info)
 {
 	struct pwm_lpss_chip *lpwm;
-- 
1.8.4.5

