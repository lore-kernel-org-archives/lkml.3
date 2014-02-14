Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaBNQMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:12:50 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64982 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaBNQMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:12:49 -0500
Message-ID: <52FE407C.3080002@gmail.com>
Date: Fri, 14 Feb 2014 18:12:44 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
References: <52FD08D1.3030405@gmail.com> <20140213182105.GN13576@mudshark.cambridge.arm.com> <52FD1243.9040706@gmail.com> <20140213192909.GO13576@mudshark.cambridge.arm.com>
In-Reply-To: <20140213192909.GO13576@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13.02.2014 21:29, Will Deacon wrote:
>
> Can you try hacking crypto/memneq.c so that it doesn't use
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS please? That would at least point the
> finger at net/mac80211/rx.c or similar.
>
> Cheers,
>
> Will
>

Well, I am lazy so I hacked net/mac80211/rx.c first:

index c24ca0d..6839c77 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1963,7 +1963,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
                 }
         }

-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+//#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
         if (skb) {
                 /* 'align' will only take the values 0 or 2 here since all
                  * frames are required to be aligned to 2-byte boundaries
@@ -1987,7 +1987,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
                         }
                 }
         }
-#endif
+//#endif

         if (skb) {
                 /* deliver to local stack */


and that seems to fix the problem.

I am not sure whom I should forward the problem.

Thanks,
Ivo
