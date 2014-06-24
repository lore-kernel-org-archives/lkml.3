Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaFXT07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:26:59 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42241 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaFXT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <1403624918.29061.16.camel@joe-AO725>
References: <20140624153959.GA19564@google.com> <1403624918.29061.16.camel@joe-AO725>
From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 24 Jun 2014 12:26:15 -0700
X-Google-Sender-Auth: qKePAIqC5fWPDNaDxdjIM_Yglyk
Message-ID: <CAGVrzcbgds+zHbTJWnUi48Nn1xPiEjGV7PGRmUX46da2CD+G=g@mail.gmail.com>
Subject: Re: [PATCH 1/1] ar7: replace mac address parsing
To: Joe Perches <joe@perches.com>
Cc: Daniel Walter <dwalter@google.com>, Ralf Baechle <ralf@linux-mips.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-24 8:48 GMT-07:00 Joe Perches <joe@perches.com>:
> On Tue, 2014-06-24 at 16:39 +0100, Daniel Walter wrote:
>> Replace sscanf() with mac_pton().
> []
>> diff --git a/arch/mips/ar7/platform.c b/arch/mips/ar7/platform.c
> []
>> @@ -307,10 +307,7 @@ static void __init cpmac_get_mac(int instance, unsigned char *dev_addr)
>>       }
>>
>>       if (mac) {
>> -             if (sscanf(mac, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
>> -                                     &dev_addr[0], &dev_addr[1],
>> -                                     &dev_addr[2], &dev_addr[3],
>> -                                     &dev_addr[4], &dev_addr[5]) != 6) {
>> +             if (!mac_pton(mac, dev_addr)) {
>
> There is a slight functional change with this conversion.
>
> mac_pton is strict about leading 0's and requires a 17 char strlen.

I do not have my devices handy, but I am fairly positive the use of
sscanf() was exactly for that, we may or may not have leading zeroes.
I am feeling a little uncomfortable with random code changes like that
without being actually able to test on real hardware that has a
variety of bootloaders and environment variables.

>
> sscanf will accept 0:1:2:3:4:5, mac_pton will not.
>
>>                       pr_warning("cannot parse mac address, "
>>                                       "using random address\n");
>
> could be coalesced and pr_warn
>
>                         pr_warn("cannot parse mac address - using random address\n");
>
>
>



-- 
Florian
