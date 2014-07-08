Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaGHADb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaGHAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>, Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 32/44] staging: comedi: das08: Correct AI encoding for das08jr-16-ao
Date: Mon,  7 Jul 2014 17:07:22 -0700
Message-Id: <20140707235859.603141174@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e6391a182865efc896cb2a8d79e07b7ac2f45b48 upstream.

The element of `das08_boards[]` for the 'das08jr-16-ao' board has the
`ai_encoding` member set to `das08_encode12`.  It should be set to
`das08_encode16` same as the 'das08jr/16' board.  After all, this board
has 16-bit AI resolution.

The description of the A/D LSB register at offset 0 seems incorrect in
the user manual "cio-das08jr-16-ao.pdf" as it implies that the AI
resolution is only 12 bits.  The diagrams of the A/D LSB and MSB
registers show 15 data bits and a sign bit, which matches what the
software expects for the `das08_encode16` AI encoding method.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/das08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -385,7 +385,7 @@ static const struct das08_board_struct d
 	 .ai = das08_ai_rinsn,
 	 .ai_nbits = 16,
 	 .ai_pg = das08_pg_none,
-	 .ai_encoding = das08_encode12,
+	 .ai_encoding = das08_encode16,
 	 .ao = das08jr_ao_winsn,
 	 .ao_nbits = 16,
 	 .di = das08jr_di_rbits,


