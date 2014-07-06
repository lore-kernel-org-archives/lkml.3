Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaGFF6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 01:58:45 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:46232 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaGFF6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 01:58:44 -0400
MIME-Version: 1.0
In-Reply-To: <53B80EFC.6020504@infradead.org>
References: <1404528619-3715-1-git-send-email-xerofoify@gmail.com>
	<53B80EFC.6020504@infradead.org>
Date: Sun, 6 Jul 2014 01:58:43 -0400
Message-ID: <CAPDOMVid83VWT4n93MjvxoWdcq2KPYren0o5ubGi+9HHY6a7EQ@mail.gmail.com>
Subject: Re: [PATCH] mips: Add #ifdef in file bridge.h
From: Nick Krause <xerofoify@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: ralf@linux-mips.org, jchandra@broadcom.com, blogic@openwrt.org,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No I didn't I finally learned how to cross compile the kernel it's not
hard just have to find the docs for it :).
Cheers Nick

On Sat, Jul 5, 2014 at 10:43 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/04/2014 07:50 PM, Nicholas Krause wrote:
>> This patch addes a #ifdef __ASSEMBLY__ in order to check if this part
>> of the file is configured to fix this #ifdef block in bridge.h for mips.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  arch/mips/include/asm/netlogic/xlp-hal/bridge.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
>> index 3067f98..4f315c3 100644
>> --- a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
>> +++ b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
>> @@ -143,7 +143,7 @@
>>  #define BRIDGE_GIO_WEIGHT            0x2cb
>>  #define BRIDGE_FLASH_WEIGHT          0x2cc
>>
>> -/* FIXME verify */
>> +#ifdef __ASSEMBLY__
>>  #define BRIDGE_9XX_FLASH_BAR(i)              (0x11 + (i))
>>  #define BRIDGE_9XX_FLASH_BAR_LIMIT(i)        (0x15 + (i))
>>
>>
>
> Hi,
>
> Where is the corresponding #endif ?
> The #endif at line 185 goes with the #ifndef __ASSEMBLY__ at line 176.
>
> I think that this patch will cause a build error (or at least a warning).
> Did you test it?
>
>
> --
> ~Randy
