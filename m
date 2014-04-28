Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaD1NkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:40:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63625 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaD1NkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:40:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rik van Riel <riel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rcu: fix build error for sysrq workaround
Date: Mon, 28 Apr 2014 15:40 +0200
Message-ID: <8486148.XCakAkJiju@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:F4HNNJJwRHr+MANEvMe80iFsRGdQ0k0xCrg0gMl+ji3
 Fh2xS9VJkUKh9EG3wb4tNWtm0mJ+TzKpW03hwoT6cyr05DPYgS
 a3CtCUm7j3FcmEI26DrDfeQ8sX3rztV9Vs+Xz97QJu6PqLupGx
 HsQ5OzbptqbKrqHHRDyryWGhMkPU2zPR0p97jW0kHQNlv/L5Yl
 QECfD8eTiC0LN+NeaJxNP+1CWQnF08ZAMEsYir2DLy4QU148Om
 Mf9uIoKN3YLTWjeaT/5NVL8QIwucTnNC4ajBzQSAMjnFHdm58c
 9KXVmavF96+X0svG4Nkaz1Fi7tAhZbsh8bgK41U46H/83laO8O
 Q4Bk2DF1FBy9YpbvX1W0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a build error in linux-next today, coming from:
http://ozlabs.org/~akpm/mmots/broken-out/sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

I saw the problem has already been reported by other people, but couldn't find
a fix. This is what I used locally to avoid the build error. Not sure if it's
correct to do nothing though.

Please just ignore if the problem has already been solved independently.

	Arnd

(re-sent with mailing list on Cc)

9<-----------
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] rcu: fix build error for sysrq workaround

Patch "sysrq,rcu: suppress RCU stall warnings while sysrq runs"
introduced two new functions, but they are unavailable if
CONFIG_RCU_STALL_COMMON is not set, so we have to provide
an alternative implementation, doing nothing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e9cc71c..26e1771 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -247,8 +247,15 @@ void rcu_idle_enter(void);
 void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
+
+#ifdef CONFIG_RCU_STALL_COMMON
 void rcu_sysrq_start(void);
 void rcu_sysrq_end(void);
+#else
+static inline void rcu_sysrq_start(void) { }
+static inline void rcu_sysrq_end(void) { }
+
+#endif
 
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
