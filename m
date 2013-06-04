Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3FDXNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:13:20 -0400
Received: from 1wt.eu ([62.212.114.60]:35443 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab3FDWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:19 -0400
Message-Id: <20130604172133.414290073@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 075/184] staging: comedi: das08: Correct AO output for
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 das08jr-16-ao

From: Ian Abbott <abbotti@mev.co.uk>

commit 61ed59ed09e6ad2b8395178ea5ad5f653bba08e3 upstream.

Don't zero out bits 15..12 of the data value in `das08jr_ao_winsn()` as
that knobbles the upper three-quarters of the output range for the
'das08jr-16-ao' board.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/das08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index f425833..c05cb4b 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -652,7 +652,7 @@ static int das08jr_ao_winsn(struct comedi_device *dev,
 	int chan;
 
 	lsb = data[0] & 0xff;
-	msb = (data[0] >> 8) & 0xf;
+	msb = (data[0] >> 8) & 0xff;
 
 	chan = CR_CHAN(insn->chanspec);
 
-- 
1.7.12.2.21.g234cd45.dirty



