Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3GWJJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:09:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:45197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3GWJJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:09:40 -0400
Message-ID: <51EE4852.7050606@linutronix.de>
Date: Tue, 23 Jul 2013 11:09:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-7-git-send-email-bigeasy@linutronix.de> <51EE1CD2.6080406@ti.com>
In-Reply-To: <51EE1CD2.6080406@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:04 AM, George Cherian wrote:
> Hi Sebastian,
> 
>  
> On 7/22/2013 11:39 PM, Sebastian Andrzej Siewior wrote:
> 
>> This patch renames the type struct from ti81xx_driver_data to
>> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
>> member is also removed since the am33xx SoC does not have such register.
>> The interrupt is acknowledged by writting into the stat register.
>>
> 
> AM335X TRM Section 16.6.5 and 16.7.5 describes about EOI registers.
> Its at offset 0x24. Or is it that the interrupts are acknowledged even
> without writing to eoi register?

I have here "Literature Number: SPRUH73H October 2011 ­ Revised April
2013" which calls itself "AM335x ARM® CortexTM-A8 Microprocessors
(MPUs) Technical Reference Manual".
This document ends with 16.5 that means there is no chapter 16.6 or
16.7. The next one is 17.
16.5.2 and 16.5.3 describes the available registers of
USB[01]_CTRL REGISTERS which is where the EOI register is accessed. I
see here

  20h USB0IRQMSTAT
  28h USB0IRQSTATRAW0

so no 0x24 at least in my document.

Sebastian
