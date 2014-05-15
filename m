Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaEOB0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:26:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaEOB0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:26:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140515011551.26781.qmail@ns.horizon.com>
References: <20140515011551.26781.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 14 May 2014 18:26:09 -0700
To: George Spelvin <linux@horizon.com>, pavel@ucw.cz
CC: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Message-ID: <2e076c13-84aa-4da4-a443-7e8fcc462fc9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to me to make the code easier to read, not harder. That was the whole point.

On May 14, 2014 6:15:51 PM PDT, George Spelvin <linux@horizon.com> wrote:
>H. Peter Anvin wrote:
>> If the whole point of this is to use it for MMC/SD cards, why not
>just
>> also subsume the OR 1 and call it crc7_mmc() or something like that.
>>
>> (Which I'm all for doing... I don't know of any other crc7 users.)
>
>You'll find all users in my patch series.  2/3 updates the MMC
>card, while 3/3 hits drivers/net/wireless/ti/wl1251/spi.c and
>drivers/net/wireless/ti/wlcore/spi.c (which I'm pretty sure aren't
>MMC/SPI cards).
>
>Now, it turns out that they *also* set the lsbit (calling it
>WSPI_INIT_CMD_END).  However, it's not possible to put that into the
>CRC
>table (it would mess up all bytes but the last), so an explicitly coded
>"| 1" is required at the end.  Thic ends up being no saving at all to
>execution path length, and only moves one instruction from three
>drivers
>to shared code.  While making it harder to read the drivers.
>
>A microscopic space saving (if and only if you have more than one of
>these
>drivers loaded) and no performance improvement didn't seem worth it to
>me.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
