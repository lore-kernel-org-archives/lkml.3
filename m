Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaIXD24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:28:56 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55028 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIXD2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <5421174A.7060101@zonque.org>
References: <1411445057-30048-1-git-send-email-mranostay@gmail.com>
	<1411445057-30048-2-git-send-email-mranostay@gmail.com>
	<5421174A.7060101@zonque.org>
Date: Tue, 23 Sep 2014 20:28:53 -0700
Message-ID: <CAKzfze_EiS1XAmDsA9cFMuxKhOx-Lea7ruxLeQiJdbtfVaphmA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cap1106: Add support for various cap11xx devices
From: Matt Ranostay <mranostay@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Kumar Gala <galak@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:46 PM, Daniel Mack <daniel@zonque.org> wrote:
> On 09/23/2014 06:04 AM, Matt Ranostay wrote:
>> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
>> index d70b65a..07f9e88 100644
>> --- a/drivers/input/keyboard/cap1106.c
>> +++ b/drivers/input/keyboard/cap1106.c
>> @@ -55,8 +55,6 @@
>>  #define CAP1106_REG_MANUFACTURER_ID  0xfe
>>  #define CAP1106_REG_REVISION         0xff
>>
>> -#define CAP1106_NUM_CHN 6
>> -#define CAP1106_PRODUCT_ID   0x55
>>  #define CAP1106_MANUFACTURER_ID      0x5d
>>
>>  struct cap1106_priv {
>> @@ -64,7 +62,25 @@ struct cap1106_priv {
>>       struct input_dev *idev;
>>
>>       /* config */
>> -     unsigned short keycodes[CAP1106_NUM_CHN];
>> +     u32 *keycodes;
>> +     unsigned int num_channels;
>> +};
>> +
>> +struct cap11xx_hw_model {
>> +     uint8_t product_id;
>> +     unsigned int num_channels;
>> +};
>> +
>> +enum {
>> +     CAP1106,
>> +     CAP1126,
>> +     CAP1188,
>> +};
>> +
>> +struct cap11xx_hw_model cap11xx_devices[] = {
>
> This can be static const.
>
D'oh how did I miss that?

> And, as I said, there should be a 3rd patch that renames the file and
> its functions, structs, defines etc to the more generic "11xx" variants.
>

Ok will do and resubmit.

>
> Thanks,
> Daniel
>
