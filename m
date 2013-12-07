Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3LGKEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:04:00 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:20630 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3LGKD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:03:57 -0500
Message-ID: <52A2ECE4.3050407@c-s.fr>
Date: Sat, 07 Dec 2013 10:39:48 +0100
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc 8xx: Loading kernels over 8Mbytes without CONFIG_PIN_TLB
References: <20131127110406.6DC8E1A504F@localhost.localdomain> <1386356996.7375.120.camel@snotra.buserror.net>
In-Reply-To: <1386356996.7375.120.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 131206-1, 06/12/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 06/12/2013 20:09, Scott Wood a écrit :
> On Wed, 2013-11-27 at 12:04 +0100, Christophe Leroy wrote:
>> Today, the only way to load kernels whose size is greater than 8Mbytes is to
>> activate CONFIG_PIN_TLB. Otherwise, the physical memory initially mapped is
>> limited to 8Mbytes. This patch sets up 24 Mbytes of initial memory regardless
>> of whether CONFIG_PIN_TLB is active or not. It allows to load "big" kernels
>> (for instance when activating CONFIG_LOCKDEP_SUPPORT) without having
>> to activate CONFIG_PIN_TLB.
> So, what happens on boards with less than 24M memory present?  Even if
> you avoid explicitly referencing those addresses, what if there is a
> speculative access -- or does 8xx not do that?
>
> -Scott
>

Function setup_initial_memory_limit() in mm/init_32.c defines the limits 
based on the parameters given by the bootloader.
As far as I know, the 8xx doesn't do speculative access just because an 
area is loaded in a TLB Entry.

Christophe

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

