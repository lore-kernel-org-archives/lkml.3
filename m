Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaHFRyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:54:51 -0400
Received: from sf2.bxl.stone.is ([5.134.1.239]:42072 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaHFRyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:54:49 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53E2618F.6040208@acm.org>
Date: Wed, 06 Aug 2014 19:10:39 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] spin_lock_nested(): Always evaluate second argument
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org> <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com> <53E260D9.6030803@acm.org>
In-Reply-To: <53E260D9.6030803@acm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Filter-ID: XtLePq6GTMn8G68F0EmQvdthj6rk7ohlAkaRQG+cDaLZlN3ufQ0ZRHdy43341LQ0JYRGiu4wDuX/
 sGw1Y7RAsZ3WBw9ZlycipwBG3jGu9D8JBgu10R0foqIRsBJqRnurUO/XCGxJVedBWv8BXp6lSPrf
 oA0XngOaR5RLFk6kKY8+X6tyUZ34Ozy6TOwmaHPzFR2lHDoBQ4zwtMehH4SfWgLcNhHqvET8hkHK
 4DD3CZT4SL0VvzAbTStaxE3e6xctxkHXgTSJC2+q+O2n2sPwh+CpLQk2sgUsKd5RNPNJeN3I5L/U
 AJH41ve/RciJD7RwcMm6IODZgOZ9Y8BEoKFU+aMoXDjs2Ljwo94KTt37C74ccBIk1Sag4dKiqCrF
 8eZZsQYibGPulATAPqOguWXWenmy4p4jVbvkvQrOImHI+zH4ns3e6vWEaK66hz4t87L5hVQSL57W
 w8nd1cTP1twpFFTUuHOuOBA828Pfce2frIKvtUus/ypEW5W6Dw4DmSZF9OoIMWCP9bnVs5BJWbbt
 5dM+m4WpRRDP6YzwkAPgQJZcv8AnfPB9HqHgcyCJwUz8oOSQKVK4yyKUlGmQMgPOfIQtTQXMrNAv
 J7CbCYezRVuhdlkpfoNhtgWYwB/e4S2rpoRvMJWweGFGUUnI6wOX8j4FS3UlU37B6qPMab0LB93J
 IFkIZaBCBQxuHnm838r53JPVY43DX2xu13bzR77n10CVt0DUeFU/MBWnkHtFiUWEyj6NsnagMRqM
 8j9gdkiQLAkCbSNS+uGS3B2gbpH+CQoQ5a8OxA97GyhrhjQrc+GSwIY88rqRZEl0ZFXSwVn3
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: cPaH8lomer6UwsJ3BnJDysg56Hzi1baYmi2c/60G48S0VFDyP20las9Mq1v6nXmfrqKtWpHLpkE8
 c09GKJn2tzESbR0qDNQvD2Wz28fGl5dMqRJTan78INzQLlEGX/jFRST5X0bRoOLYozD+qqgg13U4
 H51jyCSmLdA2hPaiVpwYWaeThsiFlmPt/lOSmjPe4E14kOfCIshTUQiezlwqTmqK95LAXg+Ea3Jb
 F9WwpaZ//Un1C5ivAWoOksRE8XtOTT9J6CK2j8j7/AJ9TNml+IbyXSJXjZjMx+Tok7jY2RMn3BMy
 1LAXbQrwm8OFnukCzIqp+DPfGh5dERZ2moanpvSHZh7bSeXsAMtaPF0u443E3nrK/nhevL/uAoHg
 xNXar0XzbLB8Pru9OEB7tNjak+6bpnvFzMd6SECQNf1u/wGWAJzP31LdUHDVnH0aZDcVCxO6ac9X
 hDc8gFJxmNF1qg==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluating a macro argument only if certain configuration options
have been selected is confusing and error-prone. Hence always
evaluate the second argument of spin_lock_nested().

An intentional side effect of this patch is that it avoids that
the following warning is reported for netif_addr_lock_nested()
when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:

include/linux/netdevice.h: In function 'netif_addr_lock_nested':
include/linux/netdevice.h:2865:6: warning: variable 'subclass' set but not used [-Wunused-but-set-variable]
  int subclass = SINGLE_DEPTH_NESTING;
      ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/spinlock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3f2867f..485d5dc 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -197,7 +197,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
+# define raw_spin_lock_nested(lock, subclass)		\
+	((void)(subclass), _raw_spin_lock(lock))
 # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
 #endif
 
-- 
1.8.4.5

