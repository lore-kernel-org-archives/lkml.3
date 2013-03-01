Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3CAOCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:02:30 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53608 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3CAOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <512F8D8B.3070307@suse.cz>
References: <5121C7AF.2090803@numascale-asia.com>
	<CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
	<51254AD2.7000906@suse.cz>
	<CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
	<512F8D8B.3070307@suse.cz>
Date: Fri, 1 Mar 2013 22:02:28 +0800
Message-ID: <CAJd=RBD=eT=xdEy+v3GBZ47gd47eB+fpF-3VtfpLAU7aEkZGgA@mail.gmail.com>
Subject: Re: kswapd craziness round 2
From: Hillf Danton <dhillf@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 1:02 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>
> Ok, no difference, kswap is still crazy. I'm attaching the output of
> "grep -vw '0' /proc/vmstat" if you see something there.
>
Thanks to you for test and data.

Lets try to restore the deleted nap, then.

Hillf
--- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
+++ b/mm/vmscan.c	Fri Mar  1 21:55:40 2013
@@ -2817,6 +2817,10 @@ loop_again:
 		 */
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
+
+		if (sc.priority < DEF_PRIORITY - 2)
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
+
 	} while (--sc.priority >= 0);

 out:
--
