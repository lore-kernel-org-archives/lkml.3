Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKGM72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:59:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45707 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaKGM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:59:26 -0500
Message-ID: <545CC0E8.4070102@message-id.googlemail.com>
Date: Fri, 07 Nov 2014 13:54:00 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [REGRESSION] in 3.18-rc1: ppp crashes kernel
References: <545CA8B6.2060608@message-id.googlemail.com> <1415361193.4390.46.camel@x220> <545CB37C.6080804@message-id.googlemail.com>
In-Reply-To: <545CB37C.6080804@message-id.googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2014 um 12:56 schrieb Stefan Seyfried:
> Hi Paul,
> 
> Am 07.11.2014 um 12:53 schrieb Paul Bolle:
>> Wild guess: is CONFIG_RCU_NOCB_CPU perhaps set in your
>> v3.18-rc3 .config?
> 
> Yes it is:
> tux@linux:~> zgrep CONFIG_RCU_NOCB_CPU /proc/config.gz
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> 
> And I'll try without it, but looking at the backtrace and the actual
> BUG_ON() in the code, I cannot really believe it is the real problems.
> 
> But I'll try with the config changed and with the above line removed.

JFTR, this did not help:
tux@linux:~/linux> zgrep CONFIG_RCU_NOCB_CPU /proc/config.gz
# CONFIG_RCU_NOCB_CPU is not set

neither did:

--- a/init/main.c
+++ b/init/main.c
@@ -583,7 +583,7 @@ asmlinkage __visible void __init start_kernel(void)
        early_irq_init();
        init_IRQ();
        tick_init();
-       rcu_init_nohz();
+//     rcu_init_nohz();
        init_timers();
        hrtimers_init();
        softirq_init();
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
