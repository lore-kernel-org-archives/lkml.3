Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371Ab3DCFoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:44:19 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:59824 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762340Ab3DCFoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:44:17 -0400
Message-ID: <515BC1AF.1070103@izyk.ru>
Date: Wed, 03 Apr 2013 09:44:15 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: n_tty_write() going into schedule but NOT coming out
References: <5156DC21.20901@synopsys.com>
In-Reply-To: <5156DC21.20901@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, try this patch maybe it can help localize your problem.

 drivers/tty/n_tty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 05e72be..28f15d0 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -230,6 +230,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
 	ldata->canon_head = ldata->canon_data = ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 	n_tty_set_room(tty);
+	check_unthrottle(tty);
 }
 
 /**
