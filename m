Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3JVPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:13:22 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47927 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3JVPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:13:19 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Eric Dumazet <edumazet@google.com>, Helge Deller <deller@gmx.de>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the net-next tree
Date: Tue, 22 Oct 2013 17:10:45 +0200
Message-Id: <1382454649-16442-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382369814-7582-1-git-send-email-treding@nvidia.com>
References: <1382369814-7582-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the net-next tree got a conflict in

	arch/parisc/include/uapi/asm/socket.h

caused by commits 62748f3 (net: introduce SO_MAX_PACING_RATE) and 1a0e62d
(parisc: break out SOCK_NONBLOCK define to own asm header file).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc arch/parisc/include/uapi/asm/socket.h
index 9f2174f,7c614d0..f33113a
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@@ -75,4 -75,11 +75,6 @@@
  
  #define SO_BUSY_POLL		0x4027
  
+ #define SO_MAX_PACING_RATE	0x4048
+ 
 -/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
 - * have to define SOCK_NONBLOCK to a different value here.
 - */
 -#define SOCK_NONBLOCK   0x40000000
 -
 -#endif /* _ASM_SOCKET_H */
 +#endif /* _UAPI_ASM_SOCKET_H */
