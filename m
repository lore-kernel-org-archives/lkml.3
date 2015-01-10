Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbbAJOG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:06:26 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57367 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbbAJOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:06:24 -0500
Message-ID: <54B131D7.4040705@kernel.org>
Date: Sat, 10 Jan 2015 14:06:15 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Daniel Baluta <daniel.baluta@intel.com>
CC: Kevin Tsai <ktsai@capellamicro.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
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
Subject: Re: [PATCH V1 1/1] iio: Added Capella cm3232 ambient light sensor
 driver.
References: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>	 <CAEnQRZBD2NMYRp1cW0J2ssT4CT=0jSM=X6ByHQiUrA0ueV8fRA@mail.gmail.com>	 <1420463396.2652.8.camel@perches.com>	 <CAEnQRZBmwurFCJU4E4ArO8waU+YcGWrRYr3DRVxq9haduX2t=w@mail.gmail.com>	 <1420476166.2652.14.camel@perches.com>	 <CAEnQRZA6=FK8CaJvh7kxOEAyDLQQE77xZ02UofLUUT67yZG8bg@mail.gmail.com> <1420480611.2652.19.camel@perches.com>
In-Reply-To: <1420480611.2652.19.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/15 17:56, Joe Perches wrote:
> On Mon, 2015-01-05 at 19:50 +0200, Daniel Baluta wrote:
>> On Mon, Jan 5, 2015 at 6:42 PM, Joe Perches <joe@perches.com> wrote:
>>> On Mon, 2015-01-05 at 16:20 +0200, Daniel Baluta wrote:
>>>> On Mon, Jan 5, 2015 at 3:09 PM, Joe Perches <joe@perches.com> wrote:
>>>>> On Mon, 2015-01-05 at 12:51 +0200, Daniel Baluta wrote:
>>>>>> On Thu, Jan 1, 2015 at 2:10 AM, Kevin Tsai <ktsai@capellamicro.com> wrote:
>>>>>>> CM3232 is an advanced ambient light sensor with I2C protocol interface.
>>>>>>> The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
>>>>>>> to configure register is byte mode, but reading ALS register requests to
>>>>>>> use word mode for 16-bit resolution.
>>> []
>>>>>> You could directly return i2c_smbus_write_byte_data(..).
>>>>>
>>>>> Sometimes it's better to return a specific value
>>>>> for the error instead of depending on correctness
>>>>> of all the indirect functions in the call chain.
>>>>>
>>>>> In this case, all the smbus_xfer functions must
>>>>> return 0 on success.  Do they?
>>>>
>>>> Yes.
>>>>
>>>> http://lxr.free-electrons.com/source/drivers/i2c/i2c-core.c#L2845
>>>
>>> This doesn't show that adapter->algo->smbus_xfer()
>>> returns 0, you have to look at the code for that
>>> indirectly called function.
>>
>> I based my answer on the comment at the top of the function:
>>
>> 2845  * This executes an SMBus protocol operation, and returns a negative
>> 2846  * errno code else zero on success.
> 
> Sure, but comments and code often differ and the
> implementation of any of those smbus_xfer functions
> could return a positive value like the byte value or
> the number of bytes written instead of 0.
> 
> For correctness, you'd have to inspect them all.
> 
> If some new future smbus_xfer function was written
> incorrectly, the return value from this function could
> now be positive.
> 
That would however, clearly be a bug and likely to cause all
sorts of issues elsewhere given the documentation requires that
it does return 0 on success and people will have been
relying on it.

Jonathan
> cheers, Joe
> 

