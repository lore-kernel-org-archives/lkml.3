Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaBZUeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:34:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:12268 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125AbaBZUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:34:29 -0500
Date: Wed, 26 Feb 2014 15:34:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Subject: [for-next][PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
Message-ID: <20140226153428.24ee601c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

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
