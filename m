Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3FLQyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:54:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42221 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290Ab3FLQyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:54:20 -0400
Message-Id: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com>
X-Sasl-Enc: sPiSdnlq0CtLz61oUbrkzvzpF5whkLa4KYrGkl4SuPuu 1371056055
From: Simon Brown <lists@700c.org>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-5ae8e04c
Subject: Accessing more than 2GB of memory with a 32 bit kernel
Date: Wed, 12 Jun 2013 17:54:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For the sake of an old prototype peripheral I'm using a non PAE 32 bit
x86 kernel and I'm having trouble accessing memory above 2 GB. The
system has 4GB installed and all is well with a PAE kernel. 

I'm obviously expecting to lose some memory due to memory mapped devices
but I wasn't expecting to lose 2GB. Instead I'm suspecting a BIOS bug.
The system reports:
free -m
             total       used       free     shared    buffers    
             cached
Mem:          2012        491       1521          0         40       
277

The mtrr table looked odd so I enabled sanitisation:
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 2GB, range: 2GB, type UC
[    0.000000] reg 1, base: 0GB, range: 4GB, type WB
[    0.000000] reg 2, base: 4GB, range: 2GB, type WB
[    0.000000] total RAM covered: 4096M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 2     
lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 4GB, range: 2GB, type WB

I don't understand the gap in the new table.

The motherboard is an Asus P5K with an Intel® P35 chipset. I'm using the
ubuntu lucid kernel (2.6.32) but the problem is also present with the
ubuntu precise kernel.
I'm at the limit of my understanding, can anyone advise how to debug
further?

Thanks,

Simon
