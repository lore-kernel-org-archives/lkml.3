Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3JUJbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:31:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39343 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab3JUIup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ian Abbott" <abbotti@mev.co.uk>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.665687889@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/149] staging: comedi: dt282x: dt282x_ai_insn_read()
 always fails
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
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

