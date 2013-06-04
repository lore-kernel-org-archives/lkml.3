Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3FDWvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:51:39 -0400
Received: from 1wt.eu ([62.212.114.60]:35834 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab3FDWoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:01 -0400
Message-Id: <20130604172133.249243991@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 071/184] staging: comedi: s626: dont dereference insn->data
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit b655c2c4782ed3e2e71d2608154e295a3e860311 upstream.

`s626_enc_insn_config()` is incorrectly dereferencing `insn->data` which
is a pointer to user memory.  It should be dereferencing the separate
`data` parameter that points to a copy of the data in kernel memory.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 80d2787..7a7c29f 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2330,7 +2330,7 @@ static int s626_enc_insn_config(struct comedi_device *dev,
 	/*   (data==NULL) ? (Preloadvalue=0) : (Preloadvalue=data[0]); */
 
 	k->SetMode(dev, k, Setup, TRUE);
-	Preload(dev, k, *(insn->data));
+	Preload(dev, k, data[0]);
 	k->PulseIndex(dev, k);
 	SetLatchSource(dev, k, valueSrclatch);
 	k->SetEnable(dev, k, (uint16_t) (enab != 0));
-- 
1.7.12.2.21.g234cd45.dirty



