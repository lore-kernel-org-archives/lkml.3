Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3IYBd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:33:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3IYAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 09/40] staging: comedi: dt282x: dt282x_ai_insn_read() always fails
Date: Tue, 24 Sep 2013 17:11:41 -0700
Message-Id: <20130925001042.973337217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/dt282x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -407,8 +407,9 @@ struct dt282x_private {
 			}					\
 			udelay(5);				\
 		}						\
-		if (_i)						\
+		if (_i) {					\
 			b					\
+		}						\
 	} while (0)
 
 static int dt282x_attach(struct comedi_device *dev,


