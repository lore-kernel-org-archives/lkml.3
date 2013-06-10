Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3FJU33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:29:29 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:5838 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab3FJU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:29:28 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 16:29:28 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjtbABK/CFFFxKyU/2dsb2JhbABEgkADgQWzWoEegnWDcI12oAihIo1hgykDpHqBXoMT
X-IPAS-Result: AjtbABK/CFFFxKyU/2dsb2JhbABEgkADgQWzWoEegnWDcI12oAihIo1hgykDpHqBXoMT
X-IronPort-AV: E=Sophos;i="4.84,565,1355115600"; 
   d="scan'208";a="16066927"
Subject: 3.10.0-rcX vmstat regression
From: Shane Shrybman <shrybman@teksavvy.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 10 Jun 2013 16:19:56 -0400
Message-Id: <1370895596.4198.17.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

x86_64 with 32 bit user space, seen on all 3.10.0-rc's

A typical 'vmstat 1' run looks like this:

~$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 0  0  0 3624776  26060 209808  0   0  1232     7  399  463  1  0 81 18
 0  0  0 3624816  26060 209856  0   0     0     0  625  526  0  0 100  0
 0  0  0 3624612  26064 209852  0   0     4    56 1174 1574  0  0 99  1
 1  0  0 3624652  26064 209900  0   0     4     0 1501 2126  0  0 100  0
 1  0  0 3624576  26076 209888  0   0     8   132 1299 1941  0  0 98  2
 1  0  0 3624044  26088 210268  0   0   380     0 1642 2996  0  0 93  7
 1  0  0 3628992  26140 219896  0   0  2783     7 1727 3284  0  0 85 15
 0  1  0 3588504  26288 244572  0   0  5955     0 2096 3874  0  0 27 73
 1  2  0 3572732  26428 253152  0   0  8792   212 1730 2374  0  0 27 73
 1  7  0 3566128  26492 257696  0   0  1915   268 1832 2885  0  0 11 89
 5 37  0 3527996  26576 270212  0   0  5668     0 2382 5117  0  0  9 91
 3  3  0 3471676  26668 284616  0   0  8504    12 2334 4502  0  0 15 85
 1  5  0 3485732  26852 264932  0   0  4556     0 1861 3648  0  0  8 92
 3  4  0 3438112  26872 270956  0   0  1822     0 1770 5000  0  0  0 100
 5  2  0 3405560  26916 274628  0   0  3413    96 2360 5571  0  0  9 91
 5  1  0 3378800  26952 273024  0   0  1805     0 1968 4489  0  0  0 100
Floating point exception

Two problems are shown: the floating point exception and the user and
system stats are always 0, it looks like us and sys time are showing up
as wait time.

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ_FULL_ALL=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

Sorry if this report is a duplicate,

Shane

