Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIVKsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:48:03 -0400
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:56537 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaIVKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140922095939.GB1406@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
	<20140920121242.GA3833@katana>
	<CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
	<20140922095939.GB1406@katana>
Date: Mon, 22 Sep 2014 12:47:59 +0200
Message-ID: <CAE0=X_1v_1eNr=dPTgofamFuy6zP9ff=LS7dyexj4CeutDqaPA@mail.gmail.com>
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

On Mon, Sep 22, 2014 at 11:59 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> >> +static int
>> >> +axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
>> >> +{
>> >> +     u32 int_mask = MST_STATUS_ERR | MST_STATUS_SNS;
>> >> +     u32 rx_xfer, tx_xfer;
>> >> +     u32 addr_1, addr_2;
>> >> +     int ret;
>> >> +
>> >> +     if (msg->len == 0 || msg->len > 255)
>> >> +             return -EINVAL;
>> >
>> > Ouch, really? Maybe we should warn the user here.
>>
>> Yeah, the transfer length register limits the length to 255. I'll add
>> a warning here.
>
> Please also add this information to the Kconfig description and
> somewhere at the top of the source file. This is an important flaw which
> people should easily find out about.
>

You are referring to the "len <= 255" restriction being the flaw here,
right? I'll add a note to Kconfig and the driver about that.

The other part of the condition (msg->len == 0) should actually go
away. The controller can do zero-length-data transfers. I'll fix that
for next round.

/Anders
