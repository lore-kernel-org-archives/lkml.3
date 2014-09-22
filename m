Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaIVMS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:18:27 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:36076 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaIVMSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140922110455.GA1463@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
	<20140920121242.GA3833@katana>
	<CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
	<20140922095939.GB1406@katana>
	<CAE0=X_1v_1eNr=dPTgofamFuy6zP9ff=LS7dyexj4CeutDqaPA@mail.gmail.com>
	<20140922110455.GA1463@katana>
Date: Mon, 22 Sep 2014 14:18:24 +0200
Message-ID: <CAE0=X_2bZQSk=hBm4FoffOiVNwebHRm7XmnBwOa=rUhXHjsuLQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 1:04 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> >> >> +     if (msg->len == 0 || msg->len > 255)
>> >> >> +             return -EINVAL;
>> >> >
>> >> > Ouch, really? Maybe we should warn the user here.
>> >>
>> >> Yeah, the transfer length register limits the length to 255. I'll add
>> >> a warning here.
>> >
>> > Please also add this information to the Kconfig description and
>> > somewhere at the top of the source file. This is an important flaw which
>> > people should easily find out about.
>> >
>>
>> You are referring to the "len <= 255" restriction being the flaw here,
>> right? I'll add a note to Kconfig and the driver about that.
>
> Yes, I meant that. I just remembered we should do something else:
>
> Remove I2C_FUNC_I2C (because it cannot do endless transfers) from
> functionality and simply use I2C_FUNC_SMBUS_I2C_BLOCK which does I2C
> like transfers with the SMBus Limit of 32 bytes. It seems PMBus allows
> for 255 byte which this HW could support, yet I don't recall we have
> support for that size currently.
>

Just tried this out... With the above change (I2C_FUNC_I2C replaced
with I2C_FUNC_SMBUS_I2C_BLOCK) an EEPROM device fails (at24 driver)
since it can't do a 16-bit offset when using the SMBUS_I2C_BLOCK
transfer.

Would you be OK with keeping the I2C_FUNC_I2C capability and
documenting the restriction (as per your initial suggestion)?

/Anders
