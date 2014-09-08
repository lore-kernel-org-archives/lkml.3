Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaIHRPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:15:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43993 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaIHRPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140908163058.GF9560@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
	<1409930279-1382-3-git-send-email-octavian.purdila@intel.com>
	<20140908144447.GD9560@localhost>
	<CAE1zot+R25OAu9d9WB2tOFqO9J9m-Vwo25msn6TD2HxseBTUzQ@mail.gmail.com>
	<20140908163058.GF9560@localhost>
Date: Mon, 8 Sep 2014 20:15:07 +0300
Message-ID: <CAE1zotJomxwAJA3aXm9MHnHd5Pg9V=K7XaptOPWkArV0jio4DQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 7:30 PM, Johan Hovold <johan@kernel.org> wrote:
> On Mon, Sep 08, 2014 at 06:57:29PM +0300, Octavian Purdila wrote:
>> On Mon, Sep 8, 2014 at 5:44 PM, Johan Hovold <johan@kernel.org> wrote:
>>
>> <snip>
>>
>> Hi Johan,
>>
>> Again, thanks for the detailed review, I am addressing your review
>> comments as we speak. Some questions below.
>>
>> <snip>
>>
>> > > +     int ret, len;
>> > > +     struct tx_data {
>> > > +             u8 port;
>> > > +             u8 addr;
>> > > +             u8 mem_addr_len;
>> > > +             __le32 mem_addr;
>> > > +             __le16 buf_len;
>> > > +             u8 buf[DLN2_I2C_MAX_XFER_SIZE];
>> > > +     } __packed tx;
>> >
>> > Allocate these buffers dynamically (possibly at probe).
>> >
>>
>> I double checked this, and DLN2_I2C_MAX_XFER_SIZE should actually be <
>> 64 as the USB endpoint configuration max packet size is 64. In this
>> case, can we keep it on the stack?
>
> It's better to lift that restriction and allocate it dynamically. Using
> larger buffers (> EP size) is also more efficient.
>
>> <snip>
>>
>> > > +     int ret, buf_len, rx_len = sizeof(rx);
>> >
>> > Again, one declaration per line.
>>
>> AFAICS there are many places where declaration on the same line
>> (initialization included) are used. When did this became a coding
>> style issue?
>
> It's ugly, hurts readability, and can also obfuscate the fact that your
> function really needs to be refactored.
>
> And it's in the CodingStyle:
>
>         "To this end, use just one data declaration per line (no commas
>         for multiple data declarations)."
>

OK, I always thought that was for when declaring structures/unions.
Just one more question on this subject: is the following allowed:

int ret, len;

or should it be:

int ret;
int len;
