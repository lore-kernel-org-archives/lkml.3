Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3EMMy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:54:57 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:42640 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EMMyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:54:55 -0400
Date: Mon, 13 May 2013 14:54:52 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (avr)
Message-ID: <20130513125452.GA9769@samfundet.no>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
 <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
 <alpine.DEB.2.00.1305122244300.5463@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1305122244300.5463@ayla.of.borg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 12 May 2013 22:45:01 +0200 or thereabout, Geert Uytterhoeven wrote:
> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
>> However, the full list of errors isn't that unmanageable, so I'm following
>> up with a digested list...
> 
> (.init.text+0x540): undefined reference to `atmel_default_console_device': 1 errors in 1 logs
> 	v3.10-rc1/avr32/avr32-allnoconfig
> 	Patch sent last February

I recall to have acked patch(es) related to the serial (console) driver.

It is caused by CONFIG_SERIAL_ATMEL no set in .config, but the machine code
still writes to atmel_default_console_device when you call
at32_setup_serial_console().

Two ways to fix, either select the SERIAL_ATMEL symbol or ifdef around the
atmel_default_console_device assignment in the machine code.

> vsprintf.c:(.text+0x8de): relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+ae0: 1 errors in 1 logs
> 	v3.10-rc1/avr32/avr32-allnoconfig

I suspect this is caused by not optimizing for size.

-- 
mvh
Hans-Christian Egtvedt
