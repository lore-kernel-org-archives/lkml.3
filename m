Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3C0M2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:28:00 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60585 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3C0M17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130124140746.GI12933@pengutronix.de>
References: <1355933229-25865-1-git-send-email-christian.gmeiner@gmail.com> <20130124140746.GI12933@pengutronix.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 27 Mar 2013 13:27:38 +0100
Message-ID: <CAH9NwWeKFaZEWwK9Dio39pkVqcRUfVi=dxvoXT71csJLA13qzQ@mail.gmail.com>
Subject: Re: [PATCH] at24: extend driver to allow writing via i2c_smbus_write_byte_data
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christian Gmeiner <c.gmeiner@bachmann.info>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/24 Wolfram Sang <w.sang@pengutronix.de>:
> On Wed, Dec 19, 2012 at 05:07:09PM +0100, Christian Gmeiner wrote:
>> I have a at24 EEPROM connected via i2c bus provided by ISCH i2c
>> bus driver. This bus driver does not support
>> I2C_FUNC_SMBUS_WRITE_I2C_BLOCK and so I was looking for a way
>> to be able to write the eeprom. This patch adds support for
>> I2C_SMBUS_BYTE_DATA writing via i2c_smbus_write_byte_data.
>> It is quite slow, but it works.
>>
>> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>> ---
>>  drivers/misc/eeprom/at24.c | 35 +++++++++++++++++++++++++++++------
>>  1 file changed, 29 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
>> index 2baeec5..723b411 100644
>> --- a/drivers/misc/eeprom/at24.c
>> +++ b/drivers/misc/eeprom/at24.c
>> @@ -56,6 +56,7 @@ struct at24_data {
>>       struct at24_platform_data chip;
>>       struct memory_accessor macc;
>>       int use_smbus;
>> +     int use_smbuse_write;
>
> Can't you use the same 'use_smbus' variable and do a similar switch-case
> as in the read function?
>

Sorry for the really late answer.

I am not sure if there exits some i2c buses which have different
access methods for read and write.
E.g. I2C_FUNC_SMBUS_WRITE_I2C_BLOCK and I2C_FUNC_SMBUS_READ_BYTE_DATA

If there will never be such a combination then I can reuse the same
'use_smbus' variable.

--
Christian Gmeiner, MSc
