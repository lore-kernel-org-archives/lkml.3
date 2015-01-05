Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbbAERuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:50:37 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43767 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbAERue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <1420476166.2652.14.camel@perches.com>
References: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>
	<CAEnQRZBD2NMYRp1cW0J2ssT4CT=0jSM=X6ByHQiUrA0ueV8fRA@mail.gmail.com>
	<1420463396.2652.8.camel@perches.com>
	<CAEnQRZBmwurFCJU4E4ArO8waU+YcGWrRYr3DRVxq9haduX2t=w@mail.gmail.com>
	<1420476166.2652.14.camel@perches.com>
Date: Mon, 5 Jan 2015 19:50:32 +0200
X-Google-Sender-Auth: KVpdkJw1-ZmzxvVKmR_kmN_3HcQ
Message-ID: <CAEnQRZA6=FK8CaJvh7kxOEAyDLQQE77xZ02UofLUUT67yZG8bg@mail.gmail.com>
Subject: Re: [PATCH V1 1/1] iio: Added Capella cm3232 ambient light sensor driver.
From: Daniel Baluta <daniel.baluta@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Kevin Tsai <ktsai@capellamicro.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        Archana Patni <archana.patni@linux.intel.com>,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 6:42 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2015-01-05 at 16:20 +0200, Daniel Baluta wrote:
>> On Mon, Jan 5, 2015 at 3:09 PM, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2015-01-05 at 12:51 +0200, Daniel Baluta wrote:
>> >> On Thu, Jan 1, 2015 at 2:10 AM, Kevin Tsai <ktsai@capellamicro.com> wrote:
>> >> > CM3232 is an advanced ambient light sensor with I2C protocol interface.
>> >> > The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
>> >> > to configure register is byte mode, but reading ALS register requests to
>> >> > use word mode for 16-bit resolution.
> []
>> >> You could directly return i2c_smbus_write_byte_data(..).
>> >
>> > Sometimes it's better to return a specific value
>> > for the error instead of depending on correctness
>> > of all the indirect functions in the call chain.
>> >
>> > In this case, all the smbus_xfer functions must
>> > return 0 on success.  Do they?
>>
>> Yes.
>>
>> http://lxr.free-electrons.com/source/drivers/i2c/i2c-core.c#L2845
>
> This doesn't show that adapter->algo->smbus_xfer()
> returns 0, you have to look at the code for that
> indirectly called function.

I based my answer on the comment at the top of the function:

2845  * This executes an SMBus protocol operation, and returns a negative
2846  * errno code else zero on success.

>
>> Also, I guess kbuild test robot will complain about it, like here:
>>
>> http://marc.info/?l=linux-kernel&m=141963536230419&w=2
>
> Is the kbuild test robot now submitting patches for all
> possible coccinelle simplifications?  I don't think so.
