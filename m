Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaIHPki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:40:38 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61931 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaIHPkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:40:36 -0400
Message-ID: <540DCDF1.5060008@cogentembedded.com>
Date: Mon, 08 Sep 2014 19:40:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: pcf8563: fix uninitialized use warning
References: <3640058.m4Rfp1dmTJ@wuerfel> <540D8CA8.5020104@cogentembedded.com> <10094879.uvjB4Q3B81@wuerfel>
In-Reply-To: <10094879.uvjB4Q3B81@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2014 7:22 PM, Arnd Bergmann wrote:

>>> diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
>>> index 5a197d9dc7e7..3a6f994c4da8 100644
>>> --- a/drivers/rtc/rtc-pcf8563.c
>>> +++ b/drivers/rtc/rtc-pcf8563.c
>>> @@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
>>>        char pending;
>>>
>>>        err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
>>> -     if (err < 0)
>>> +     if (err)
>>>                return err;

>>      Returning negative values from the IRQ handler doesn't seem valid.
>> Arbitrary positive value aren't good either. Perhaps should return IRQ_NONE
>> instead?

> Good point. This is unrelated to the problem I was trying to fix, but it
> seems like a good idea to fix both.

    Then it would be good if you fix this issue with a separate patch.

> 	Arnd

WBR, Sergei

