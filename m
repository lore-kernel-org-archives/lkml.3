Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbaJDAOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:14:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaJCVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.16 230/357] iio: adc: xilinx-xadc: assign auxiliary channels address correctly
Date: Fri,  3 Oct 2014 14:30:16 -0700
Message-Id: <20141003212940.421480012@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>

commit 1887e724e2b6df06847522fe9dc2ab53639516cc upstream.

This patch fixes incorrect logic for assigning address
to auxiliary channels of xilinx xadc.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/xilinx-xadc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1126,7 +1126,7 @@ static int xadc_parse_dt(struct iio_dev
 				chan->address = XADC_REG_VPVN;
 			} else {
 				chan->scan_index = 15 + reg;
-				chan->scan_index = XADC_REG_VAUX(reg - 1);
+				chan->address = XADC_REG_VAUX(reg - 1);
 			}
 			num_channels++;
 			chan++;


