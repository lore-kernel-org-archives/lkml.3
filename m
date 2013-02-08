Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BHB27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:28:59 -0500
Received: from trent.utfs.org ([94.185.90.103]:57958 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3BHB26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:28:58 -0500
Date: Thu, 7 Feb 2013 17:28:54 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: b43: /dev/hwrng isn't random
Message-ID: <alpine.DEB.2.01.1302071727280.13050@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forwarding to lkml, not sure how many people read b43-dev...

Hi,

while playing around with this BCM4306 (b43) wifi NIC (and reporting some 
lockdep issues, [0]), I noticed that the chip could be used as a HWRNG and 
driver support for this has been added years ago - great, I never knew!

But when attempting to read from /dev/hwrng (b43 is loaded, interface is 
up & running), the device returns not random bytes, but:

$ head -c 1000 /dev/hwrng | od -x
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001740 0000 0000 0000 0000
0001750

I've used a custom-built 3.8-rc6 and a stock Debian 3.2.0-4, same results. 
I should add that this BCM4306 wifi NIC is inside an older (2005) 
PowerBook G4 laptop, so maybe it's a hardware fault. However, wifi is 
working perfectly.

I found a similar thing reported _years_ ago for the OLTP project, with 
the following note, though I could not find the exact changeset for the 
fix yet:

   https://dev.laptop.org/ticket/8089#comment:4
   > Turned out OFW wasn't turning on the AES module.

CONFIG_CRYPTO_AES is enabled in my case. On another box with an BCM4312 
chip (and a Fedora 3.7.2-204.fc18.i686 kernel) the hwrng is working.

More details, .config & lspci here:

  http://nerdbynature.de/bits/3.8.0-rc6/BCM4306/
  http://nerdbynature.de/bits/3.8.0-rc6/BCM4312/

Any thoughts how to find out if this is a software or a hardware issue?

Thanks,
Christian.

[0] http://www.spinics.net/lists/kernel/msg1477153.html
-- 
BOFH excuse #144:

Too few computrons available.
