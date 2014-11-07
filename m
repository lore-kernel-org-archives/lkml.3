Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKGL4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:56:52 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47958 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKGL4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:56:48 -0500
Message-ID: <545CB37C.6080804@message-id.googlemail.com>
Date: Fri, 07 Nov 2014 12:56:44 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] in 3.18-rc1: ppp crashes kernel
References: <545CA8B6.2060608@message-id.googlemail.com> <1415361193.4390.46.camel@x220>
In-Reply-To: <1415361193.4390.46.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Am 07.11.2014 um 12:53 schrieb Paul Bolle:
> On Fri, 2014-11-07 at 12:10 +0100, Stefan Seyfried wrote:
>> I bisected the issue multiple times and always arrived at
>>
>> # first bad commit: [d6dd50e07c5bec00db2005969b1a01f8ca3d25ef] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>
>> which is a merge commit unfortunately.
> 
> That merge commit actually does add some code:
> 
> git show d6dd50e07c5bec00db2005969b1a01f8ca3d25ef
> [...]
> diff --cc init/main.c
> index 8af2f1abfe38,e3c4cdd94d5b..c5c11da6c4e1
> --- a/init/main.c
> +++ b/init/main.c
> @@@ -583,6 -585,6 +583,7 @@@ asmlinkage __visible void __init start_
>   	early_irq_init();
>   	init_IRQ();
>   	tick_init();
> ++	rcu_init_nohz();
>   	init_timers();
>   	hrtimers_init();
>   	softirq_init();
> 
> Wild guess: is CONFIG_RCU_NOCB_CPU perhaps set in your
> v3.18-rc3 .config?

Yes it is:
tux@linux:~> zgrep CONFIG_RCU_NOCB_CPU /proc/config.gz
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y

And I'll try without it, but looking at the backtrace and the actual
BUG_ON() in the code, I cannot really believe it is the real problems.

But I'll try with the config changed and with the above line removed.

Thanks,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
