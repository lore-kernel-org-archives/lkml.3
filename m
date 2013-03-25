Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3CYPnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:43:35 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1037 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab3CYPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:43:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9195
Message-ID: <51507126.2040002@metafoo.de>
Date: Mon, 25 Mar 2013 16:45:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Paul Bolle <pebolle@tiscali.nl>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
References: <1364211831.1390.285.camel@x61.thuisdomein> <20130325152258.GA17467@roeck-us.net>
In-Reply-To: <20130325152258.GA17467@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 04:22 PM, Guenter Roeck wrote:
> On Mon, Mar 25, 2013 at 12:43:51PM +0100, Paul Bolle wrote:
>> The Kconfig symbol ADT7310 got removed in commit
>> 2b0c856ad9571013db8fc369194b7108dff3c18e ("staging:iio: Consolidate
>> adt7310 and adt7410 driver"). That commit did not touch the references
>> to CONFIG_ADT7310 and CONFIG_ADT7310_MODULE in the BF537-STAMP code.
>> Convert these now, to their ADT7410 equivalents.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Untested. This took a bit of guesswork. I guessed that multiple AD
>> drivers can be enabled at the same time in this code. And I also guessed
>> that the "adt7310" modalias is still correct.
>>
>> 1) If this passes testing it could go in stable (3.8.y).
>>
>>  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
>> index 95114ed..23bb55d 100644
>> --- a/arch/blackfin/mach-bf537/boards/stamp.c
>> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
>> @@ -700,7 +700,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
>>  };
>>  #endif
>>  
>> -#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
>> +#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
> 
> It might be easier and more future-proof to just drop the conditional.
> If the driver isn't there, it won't be loaded anyway. It would also make
> back-porting much easier.
> 
> Guenter


The situation is unfortunately really messy. The issue is that these are
add-on board and the same SPI chip select pin is used for multiple devices.
If we add the spi_board_info for all devices unconditionally the SPI core
will scream at us because we tried to register multiple devices with the
same chip select pin and none of the devices gets actually registered.

- Lars
