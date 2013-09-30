Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3I3Kgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:36:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3I3KLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/104] staging: comedi: dt282x: dt282x_ai_insn_read() always fails
Date: Mon, 30 Sep 2013 11:09:56 +0100
Message-Id: <1380535881-9239-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2c4283ca7cdcc6605859c836fc536fcd83a4525f upstream.

In dt282x_ai_insn_read() we call this macro like:
wait_for(!mux_busy(), comedi_error(dev, "timeout\n"); return -ETIME;);
Because the if statement doesn't have curly braces it means we always
return -ETIME and the function never succeeds.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 736d8fa..ec85fe2 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -277,8 +277,9 @@ struct dt282x_private {
 			}					\
 			udelay(5);				\
 		}						\
-		if (_i)						\
+		if (_i) {					\
 			b					\
+		}						\
 	} while (0)
 
 static int prep_ai_dma(struct comedi_device *dev, int chan, int size);
-- 
1.8.3.2

