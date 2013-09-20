Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3ITUXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3ITUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 28/93] staging: comedi: dt282x: dt282x_ai_insn_read() always fails
Date: Fri, 20 Sep 2013 13:08:23 -0700
Message-Id: <1379707768-1804-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 122d980..bc811dd 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -271,8 +271,9 @@ struct dt282x_private {
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
1.8.1.2

