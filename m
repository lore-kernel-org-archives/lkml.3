Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaBZKfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:35:36 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47775 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBZKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <1392284459.30853.17.camel@x220>
References: <1362744373.5994.57.camel@x61.thuisdomein>
	<1392284459.30853.17.camel@x220>
Date: Wed, 26 Feb 2014 18:35:32 +0800
Message-ID: <CAMk6uBnjEA2eozct6Q_Cm2BCrF-_3gGuNaBmtymGKYpPjoLUVw@mail.gmail.com>
Subject: Re: [PATCH] blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
From: Steven Miao <realmz6@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Feb 13, 2014 at 5:40 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> [Replaced previous maintainer and list with current maintainer and
> list.]
>
> On Fri, 2013-03-08 at 13:06 +0100, Paul Bolle wrote:
>> There's a (rather subtle) typo in "CONFIG_SND_SOC_ADV80X_MODULE". Fix it
>> once and for all by using IS_ENABLED(), which is designed to avoid
>> issues like this.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>
> Has someone ever looked at this trivial patch? The typo is still not
> fixed in v3.14-rc2.
>
>> 0) Untested! And this needs build- and runtime testing, especially for
>> the MODULE case!
>>
>> 1) There are many lines that might be converted to IS_ENABLED() in this
>> file. I'm not sure if and how that should be done.
Sorry for the late reply. There are many CONFIG_xxx ||
CONFIG_xxx_MODULE things, we need a cleanup for it under all the
stamp.c and ezkit.c.
>>
>>  arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
>> index 95114ed..1872d15 100644
>> --- a/arch/blackfin/mach-bf537/boards/stamp.c
>> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
>> @@ -985,7 +985,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>>       },
>>  #endif
>>
>> -#if defined(CONFIG_SND_SOC_ADAV80X) || defined(CONFIG_SND_SOC_ADV80X_MODULE)
>> +#if IS_ENABLED(CONFIG_SND_SOC_ADAV80X)
>>       {
>>               .modalias = "adav801",
>>               .max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
>
>
> Paul Bolle
>
-steven
