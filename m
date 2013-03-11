Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3CKQbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:31:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3CKQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:31:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/9] mfd: max8925: fix trivial build warning for non-dt
Date: Mon, 11 Mar 2013 16:31:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Qing Xu <qingx@marvell.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de> <1360880818-4071454-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1360880818-4071454-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111631.06866.arnd@arndb.de>
X-Provags-ID: V02:K0:u0FifKXkOxlz0ftXPX/+/AniUdU83Cz5GXlRV8EPocc
 PdvTB+5J0yNZNho1csGAJhT/A3kjRnmw/iao5xbzpJqh+co/Gk
 0HcTLJDd/JIK41saUN3jJ6hHi4fOiy4jHcMcCn1hYkieAF9TdE
 2O/NezKgZD4dN3CqBAKVd298Br2Sou8xt/5MFaqXnGd5UrhMRw
 M8U8lvviEFOkh4ln+uPRQAMUSv1iczxMCWjyZGnMXGApqNRCda
 T9L1smkyfhnn5n8C27rePOJI43ZWEh3CTtmgEMSotxMi0xvSgN
 E1FJ9d6YIsRbMs/QSsGlhv0Mto4aUM78enNzL1A4D+AW1SXopJ
 VuDX6fhd9/ljjgXjtWjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Arnd Bergmann wrote:
> Patch fe527ea5a "mfd: max8925: Support dt for backlight"
> added a new function for DT probing but introduced a
> build warning for the case where CONFIG_OF is disabled:
> 
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
> 
> A much nicer fix is to use the IS_ENABLED keyword to
> have the same effect of dropping the device tree specific
> function when it's not needed.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Qing Xu <qingx@marvell.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Hmm, it seems I already had this patch for the issue, but for some reason it
didn't apply for some time and when I looked at the problem again now, I found
more issues, and I'd suggest reverting commit fe527ea5a completely. There are
similar problems in the max8925_power patch.

	Arnd
