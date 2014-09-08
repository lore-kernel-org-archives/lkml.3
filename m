Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaIHPnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:43:47 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42862 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaIHPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:43:46 -0400
Message-ID: <540DCEB0.6030108@cogentembedded.com>
Date: Mon, 08 Sep 2014 19:43:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Alessandro Zummo <a.zummo@towertech.it>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] rtc: pcf8563: fix uninitialized use warning
References: <2750370.rlMuFcoBUA@wuerfel>
In-Reply-To: <2750370.rlMuFcoBUA@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2014 7:26 PM, Arnd Bergmann wrote:

> gcc-4.9 found a potential condition under which the 'pending'
> variable may be used uninitialized:

> drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
> drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

> This is because in the pcf8563_get_alarm_mode() function, we
> check any nonzero return of pcf8563_read_block_data, but
> in the irq function we only check for negative values, so
> a possible positive value does not get detected if the compiler
> chooses not to inline the entire call chain.

> Checking for any non-zero value in the interrupt handler as well
> is just as correct and lets the compiler know what we are doing,
> without needing a bogus initialization.

> As pointed out by Sergei Shtylyov, the same code section contains
> another bug: an interrupt handler is not supposed to return
> an errno value. Let's fix this as well by returning IRQ_NONE
> in case of a communication error.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

    If you're fixing both issues in one patch, it probably needs somewhat 
modified subject, like "rtc: pcf8356: fix error handling".

WBR, Sergei

