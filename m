Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3FDXD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:03:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35617 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab3FDWm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:57 -0400
Message-Id: <20130604172133.332070071@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 073/184] staging: comedi: dont dereference user memory for
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 INSN_INTTRIG

From: Ian Abbott <abbotti@mev.co.uk>

commit 5d06e3df280bd230e2eadc16372e62818c63e894 upstream.

`parse_insn()` is dereferencing the user-space pointer `insn->data`
directly when handling the `INSN_INTTRIG` comedi instruction.  It
shouldn't be using `insn->data` at all; it should be using the separate
`data` pointer passed to the function.  Fix it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/comedi_fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index b83c76f..193b836 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -809,7 +809,7 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 				ret = -EAGAIN;
 				break;
 			}
-			ret = s->async->inttrig(dev, s, insn->data[0]);
+			ret = s->async->inttrig(dev, s, data[0]);
 			if (ret >= 0)
 				ret = 1;
 			break;
-- 
1.7.12.2.21.g234cd45.dirty



