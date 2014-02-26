Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaBZU3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:29:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:9747 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974AbaBZU3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:29:39 -0500
Date: Wed, 26 Feb 2014 15:29:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
Message-ID: <20140226152937.37b5d80e@gandalf.local.home>
In-Reply-To: <530D4F9E.70704@jp.fujitsu.com>
References: <8738jatylb.wl%satoru.takeuchi@gmail.com>
	<20140224093039.6509b6cd@gandalf.local.home>
	<530D4F9E.70704@jp.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 21:21:18 -0500
MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com> wrote:

> Hmm, it seems that we need a following patch as well.
> Or, please merge with the orignal patch.

I folded this fix in, here's the final:

>From 62183dcac539a14ed0a820b8392db353d72a7d7e Mon Sep 17 00:00:00 2001
From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date: Sun, 23 Feb 2014 10:19:28 +0900
Subject: [PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf

As mentioned at commit 5a5d8e48449, we can't terminate 'virsh console'
with the default signal(INT). So it's better to set CLOSE_CONSOLE_SIGNAL
in the kvm.conf.

Link: http://lkml.kernel.org/r/8738jatylb.wl%satoru.takeuchi@gmail.com

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
[ Typo fixed by ]
Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/kvm.conf | 4 ++++
 1 file changed, 4 insertions(+)

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
-- 
1.8.5.3


