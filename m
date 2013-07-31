Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab3GaUkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:40:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33457 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab3GaUkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:40:42 -0400
Date: Wed, 31 Jul 2013 22:40:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: e1000e suspend-to-disk reboots box with 3.11-rc3+
Message-ID: <20130731204040.GE4724@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing the strange observation that when I hibernate my x230
with Linus HEAD from today + tip/master (3.11-rc3+), the box doesn't
remain off but reboots immediately.

Since I have a similar bug where an e1000e box reboots
when "Wake on LAN from S4/S5" is enabled in the BIOS
(https://bugzilla.novell.com/show_bug.cgi?id=812592) I decided to test
with LAN cable removed.

And yes, when the ethernet cable is not connected, the box hibernates
and remains off. When I hibernate with the cable attached, the box
doesn't remain off but reboots.

The card is:

[    1.620772] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.622116] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    1.623687] e1000e 0000:00:19.0: setting latency timer to 64
[    1.625160] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.626640] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    1.884432] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.885925] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 3c:97:0e:6b:ef:e7
[    1.887466] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.889089] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF

And of course, 3.10 is fine.

Any ideas?

I'll try to bisect it when I get a chance.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
