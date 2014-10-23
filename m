Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaJWFwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:52:09 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:48242 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaJWFwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <1645583.LAOF2HV7Iq@avalon>
References: <1413992061-28678-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <1645583.LAOF2HV7Iq@avalon>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 23 Oct 2014 07:51:50 +0200
X-Google-Sender-Auth: 2YexCxw_0Jo3FQrMmtpgyOYLei4
Message-ID: <CAL8zT=gUaBDiq=KC5YqCD5dqx2WO1PSXGckvchX_9XxDbJJEpw@mail.gmail.com>
Subject: Re: [PATCH] adv7604: Add DT parsing support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        wsa@the-dreams.de, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thank you for reviewing,

2014-10-23 1:53 GMT+02:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Michel,
>
> Thank you for the patch.
>
> On Wednesday 22 October 2014 17:34:21 Jean-Michel Hautbois wrote:
>> This patch adds support for DT parsing of ADV7604 as well as ADV7611.
>> It needs to be improved in order to get ports parsing too.
>
> Let's improve it then :-) The DT bindings as proposed by this patch are
> incomplete, that's just asking for trouble.
>
> How would you model the adv7604 ports ?

I am opened to suggestions :).
But it has to remain as simple as possible, ideally allowing for
giving names to the ports.
As done today, it works, ports are parsed but are all the same...

>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> ---
>>  Documentation/devicetree/bindings/media/i2c/adv7604.txt | 1 +
>>  drivers/media/i2c/adv7604.c                             | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
>> c27cede..5c8b3e6 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> @@ -10,6 +10,7 @@ Required Properties:
>>
>>    - compatible: Must contain one of the following
>>      - "adi,adv7611" for the ADV7611
>> +    - "adi,adv7604" for the ADV7604
>
> Please switch the two lines to keep them alphabetically sorted.
>>
>>    - reg: I2C slave address
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 47795ff..421035f 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -2677,6 +2677,7 @@ MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
>>
>>  static struct of_device_id adv7604_of_id[] __maybe_unused = {
>>       { .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
>> +     { .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
>
> Same comment here.

Done on my side, but will wait for your suggestions, in order to add
ports parsing ;-).

Thanks,
JM
