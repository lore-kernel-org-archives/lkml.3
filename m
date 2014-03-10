Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaCJC3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:29:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60346 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaCJC3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:29:18 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <531D237C.5070400@roeck-us.net>
Date: Sun, 09 Mar 2014 19:29:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marc van der Wal <x0r+kernel@x0r.fr>, Wim Van Sebroeck <wim@iguana.be>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] it87_wdt: Work around non-working CIR interrupts
References: <20140306093659.GA24854@freyja>
In-Reply-To: <20140306093659.GA24854@freyja>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 01:36 AM, Marc van der Wal wrote:
> From: Marc van der Wal <x0r+kernel@x0r.fr>
>
> On some hardware platforms, the it87_wdt watchdog resets the machine
> despite the watchdog daemon running and writing to /dev/watchdog.
>
> This is due to Consumer IR buffer underrun interrupts being used as
> triggers to reset the timer.  On some buggy hardware implementations
> such as the iEi AFL-12A-N270 single-board computer, this method does
> not work.
>
> However, resetting the timer by writing its original timeout value in
> its configuration register over and over again suppresses the unwanted
> reboots.
>
> Add a module option (nocir), 0 by default in order not to break existing
> setups.  Setting it to 1 enables the workaround.
>
> Fixes bug #42801 <https://bugzilla.kernel.org/show_bug.cgi?id=42801>.
> Tested primarily on Linux 3.5.7, applies cleanly on Linux 3.13.5.
>
> Signed-off-by: Marc van der Wal <x0r+kernel@x0r.fr>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


