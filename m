Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3CGJAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61332 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab3CGJAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:46 -0500
Message-ID: <51385739.20000@huawei.com>
Date: Thu, 7 Mar 2013 17:00:41 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 8/8] Documentation/sysrq: fix inconstistent help message of
 sysrq key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix sysrq documentation.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/sysrq.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 2a4cdda..8cb4d78 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -129,9 +129,9 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:

 *  Okay, so what can I use them for?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Well, un'R'aw is very handy when your X server or a svgalib program crashes.
+Well, unraw(r) is very handy when your X server or a svgalib program crashes.

-sa'K' (Secure Access Key) is useful when you want to be sure there is no
+sak(k) (Secure Access Key) is useful when you want to be sure there is no
 trojan program running at console which could grab your password
 when you would try to login. It will kill all programs on given console,
 thus letting you make sure that the login prompt you see is actually
@@ -143,20 +143,20 @@ IMPORTANT: such.                                                   :IMPORTANT
 useful when you want to exit a program that will not let you switch consoles.
 (For example, X or a svgalib program.)

-re'B'oot is good when you're unable to shut down. But you should also 'S'ync
-and 'U'mount first.
+reboot(b) is good when you're unable to shut down. But you should also
+sync(s) and umount(u) first.

-'C'rash can be used to manually trigger a crashdump when the system is hung.
+crash(c) can be used to manually trigger a crashdump when the system is hung.
 Note that this just triggers a crash if there is no dump mechanism available.

-'S'ync is great when your system is locked up, it allows you to sync your
+sync(s) is great when your system is locked up, it allows you to sync your
 disks and will certainly lessen the chance of data loss and fscking. Note
 that the sync hasn't taken place until you see the "OK" and "Done" appear
 on the screen. (If the kernel is really in strife, you may not ever get the
 OK or Done message...)

-'U'mount is basically useful in the same ways as 'S'ync. I generally 'S'ync,
-'U'mount, then re'B'oot when my system locks. It's saved me many a fsck.
+umount(u) is basically useful in the same ways as sync(s). I generally sync(s),
+umount(u), then reboot(b) when my system locks. It's saved me many a fsck.
 Again, the unmount (remount read-only) hasn't taken place until you see the
 "OK" and "Done" message appear on the screen.

@@ -165,11 +165,11 @@ kernel messages you do not want to see. Selecting '0' will prevent all but
 the most urgent kernel messages from reaching your console. (They will
 still be logged if syslogd/klogd are alive, though.)

-t'E'rm and k'I'll are useful if you have some sort of runaway process you
+term(e) and kill(i) are useful if you have some sort of runaway process you
 are unable to kill any other way, especially if it's spawning other
 processes.

-"'J'ust thaw it" is useful if your system becomes unresponsive due to a frozen
+"just thaw it(j)" is useful if your system becomes unresponsive due to a frozen
 (probably root) filesystem via the FIFREEZE ioctl.

 *  Sometimes SysRq seems to get 'stuck' after using it, what can I do?
-- 
1.7.9.7


