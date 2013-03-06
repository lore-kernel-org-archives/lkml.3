Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3CFEJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:09:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:59517 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3CFEJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:09:54 -0500
Message-ID: <5136C106.40308@huawei.com>
Date: Wed, 6 Mar 2013 12:07:34 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] sysrq: allow user trigger sysrq by upper-case character key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See the help text output of /proc/sysrq-trigger:

   SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
   memory-full-oom-kill(F) kill-all-tasks(I) ...

Most command is referenced by responding upper-case character,
this would hint user can trigger sysrq by upper-case character key,
but that's wrong, sysrq only accept lower-case character currently.

It's reasonable to let user trigger sysrq by upper-case character key.

Signed-off-by: zhnagwei(Jovi) <jovi.zhangwei@huawei.com>
---
 drivers/tty/sysrq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 3687f0c..a88908e 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -471,6 +471,8 @@ static int sysrq_key_table_key2index(int key)
 		retval = key - '0';
 	else if ((key >= 'a') && (key <= 'z'))
 		retval = key + 10 - 'a';
+	else if ((key >= 'A') && (key <= 'Z'))
+		retval = key + 10 - 'A';
 	else
 		retval = -1;
 	return retval;
-- 
1.7.9.7


