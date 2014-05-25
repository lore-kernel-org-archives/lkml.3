Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaEYMPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:15:32 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61922 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaEYMPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:15:30 -0400
Message-ID: <5381DEDC.8050204@gmail.com>
Date: Sun, 25 May 2014 15:15:24 +0300
From: Amir Vadai <amirv.mellanox@gmail.com>
Reply-To: amirv@mellanox.com
Organization: Mellanox
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, idos@mellanox.com,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Extend irq_set_affinity_notifier() to use  a call chain
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working for Mellanox on mlx4_en NIC driver.

We need to be able to be notified on irq affinity changes.
This is because, during non-stop full bandwidth traffic, napi will poll 
constantly and no interrupt will be fired. Because of that, even if the 
user changes the irq affinity, polling will continue to be done on the 
original CPU that was chosen on the first packet.
We would like to be notified when the affinity is changed. When such an 
event happen, the driver will arm the interrupts and end the napi 
session. An interrupt will start a new napi session on the right CPU.

In order to do that, I need to add a new irq affinity notification 
callback (In addition to the existing cpu_rmap notification). For that I 
would like to extend irq_set_affinity_notifier() to have a notifier 
call-chain instead of a single notifier callback.

I wanted to hear your opinion on this, and unless there is a better 
solution, will send an RFC later on.

References:
- http://patchwork.ozlabs.org/patch/65244/ - Review done by Thomas 
Glexiber to Ben Hutchings first version of the irq affinity notifiers.
- http://patchwork.ozlabs.org/patch/79593/ - Final version of 
irq_set_affinity_notifier() that was applied

Thanks,
Amir
