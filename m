Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaDAQOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:14:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:36563 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091AbaDAQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:14:15 -0400
Date: Tue, 1 Apr 2014 12:14:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Subject: [GIT PULL] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
Message-ID: <20140401121412.24945d54@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This just contains a single update by Satoru Takeuchi, which adds
CLOSE_CONSOLE_SIGNAL to the kvm.conf file, as the kvm guest requires
a different signal than a normal console uses.

Please pull the latest ktest-v3.15 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.15

Tag SHA1: 13497aad499b1d051de60c988fdbe8bcecf2fa4a
Head SHA1: 62183dcac539a14ed0a820b8392db353d72a7d7e


Satoru Takeuchi (1):
      ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf

----
 tools/testing/ktest/examples/kvm.conf | 4 ++++
 1 file changed, 4 insertions(+)
---------------------------
commit 62183dcac539a14ed0a820b8392db353d72a7d7e
Author: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Sun Feb 23 10:19:28 2014 +0900

    ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
    
    As mentioned at commit 5a5d8e48449, we can't terminate 'virsh console'
    with the default signal(INT). So it's better to set CLOSE_CONSOLE_SIGNAL
    in the kvm.conf.
    
    Link: http://lkml.kernel.org/r/8738jatylb.wl%satoru.takeuchi@gmail.com
    
    Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
    [ Typo fixed by ]
    Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/examples/kvm.conf b/tools/testing/ktest/examples/kvm.conf
index 831c7c5..fbc134f 100644
--- a/tools/testing/ktest/examples/kvm.conf
+++ b/tools/testing/ktest/examples/kvm.conf
@@ -10,6 +10,10 @@ MACHINE = Guest
 # Use virsh to read the serial console of the guest
 CONSOLE =  virsh console ${MACHINE}
 
+# Use SIGKILL to terminate virsh console. We can't kill virsh console
+# by the default signal, SIGINT.
+CLOSE_CONSOLE_SIGNAL = KILL
+
 #*************************************#
 # This part is the same as test.conf  #
 #*************************************#
