Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3AWSNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:13:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62283 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3AWSNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:13:16 -0500
MIME-Version: 1.0
In-Reply-To: <1358953697.8899.2.camel@orca.stoopid.dyndns.org>
References: <A874F61F95741C4A9BA573A70FE3998F69E1C27D@DQHE02.ent.ti.com> <1358953697.8899.2.camel@orca.stoopid.dyndns.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 23 Jan 2013 10:12:48 -0800
Message-ID: <CAK5ve-JrjV1+21KV-QdYi-qXac7LzUaw0agpEWZ_T6aDg6OM7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-lp5521: fix a build warning
To: Nathan Lynch <ntl@pobox.com>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 7:08 AM, Nathan Lynch <ntl@pobox.com> wrote:
> On Wed, 2013-01-23 at 08:07 +0000, Kim, Milo wrote:
>> This patch removes a build warning below.(ARCH=x86_64)
>>
>> drivers/leds/leds-lp5521.c: In function lp5521_firmware_loaded:
>> drivers/leds/leds-lp5521.c:257:4: warning: format %d expects argument of type in
>> t, but argument 3 has type size_t [-Wformat]
>>
>> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>> ---
>>  drivers/leds/leds-lp5521.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
>> index 80adfb4..74946f4 100644
>> --- a/drivers/leds/leds-lp5521.c
>> +++ b/drivers/leds/leds-lp5521.c
>> @@ -253,7 +253,7 @@ static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
>>       const struct firmware *fw = chip->fw;
>>
>>       if (fw->size > LP5521_PROGRAM_LENGTH) {
>> -             dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
>> +             dev_err(&chip->cl->dev, "firmware data size overflow: %zd\n",
>>                       fw->size);
>
> Documentation/printk-formats.txt says %zu is to be used for size_t.
>
> Same comment goes for patch 2/2.
>
>

I agree with Nathan here. It should be %zu and %zd is for ssize_t.
Please update and fold these 2 patches into one, Milo.

Thanks,
-Bryan
