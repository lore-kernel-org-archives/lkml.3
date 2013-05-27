Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3E0Mr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:47:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3E0Mr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:47:27 -0400
Message-ID: <51A355BC.6090309@free-electrons.com>
Date: Mon, 27 May 2013 14:46:52 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <51A34BF9.5000905@atmel.com>
In-Reply-To: <51A34BF9.5000905@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/2013 14:05, Nicolas Ferre wrote:
> On 27/05/2013 12:48, Alexandre Belloni :
>> Fixes:
>> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
>> :(.text+0x1174): undefined reference to `mdiobus_write'
>> :(.text+0x1188): undefined reference to `mdiobus_write'
>> :(.text+0x119c): undefined reference to `mdiobus_write'
>> :(.text+0x11b0): undefined reference to `mdiobus_write'
>> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
>> :(.init.text+0x1e34): undefined reference to
>> `phy_register_fixup_for_uid'
>>
>> when CONFIG_PHYLIB is not selected.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>> ---
>> Changes in v3:
>>     added SoB
>>     added Acked-By
>
> A v3 is not needed simply for this. Thanks, anyway!
>

It was not much and I have to stop forgetting my SoB ;)

> One question though: why not just add
>
>         select PHYLIB
>
> In Kconfig entry:
>
>  config MACH_SAMA5_DT
>
> ?
>

That would simply mean that you have to enable NET when using a SAMA5
which is not what every user will want.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

