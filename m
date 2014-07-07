Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaGHAsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:48:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaGGXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Micky Ching <micky_ching@realsil.com.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Subject: [PATCH 3.15 118/122] mmc: rtsx: add R1-no-CRC mmc command type handle
Date: Mon,  7 Jul 2014 16:58:00 -0700
Message-Id: <20140707235737.773165945@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Micky Ching <micky_ching@realsil.com.cn>

commit 5027251eced6e34315a52bd841279df957f627bb upstream.

a27fbf2f067b0cd ("mmc: add ignorance case for CMD13 CRC error") produced
a cmd.flags unhandled in realtek pci host driver.  This will make MMC
card fail to initialize, this patch is used to handle the new cmd.flags
condition and MMC card can be used.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -236,6 +236,9 @@ static void sd_send_cmd_get_rsp(struct r
 	case MMC_RSP_R1:
 		rsp_type = SD_RSP_TYPE_R1;
 		break;
+	case MMC_RSP_R1 & ~MMC_RSP_CRC:
+		rsp_type = SD_RSP_TYPE_R1 | SD_NO_CHECK_CRC7;
+		break;
 	case MMC_RSP_R1B:
 		rsp_type = SD_RSP_TYPE_R1b;
 		break;


