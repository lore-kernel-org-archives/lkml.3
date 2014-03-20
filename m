Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbaCTOOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:14:53 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53200 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbaCTOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:14:51 -0400
Message-ID: <532AF901.3050402@gmail.com>
Date: Thu, 20 Mar 2014 15:19:45 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT documentation
References: <20140320092639.48F68A6279@smtp3-g21.free.fr> <532ADFD8.80301@gmail.com> <20140320140156.5d768b1f@armhf> <532AEDE2.3080306@gmail.com> <20140320145221.09252bf6@armhf>
In-Reply-To: <20140320145221.09252bf6@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 02:52 PM, Jean-Francois Moine wrote:
> On Thu, 20 Mar 2014 14:32:18 +0100
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> Ok, I had another round of google'ing and found this:
>> http://hipstercircuits.com/wp-content/uploads/2013/05/TDA19988.pdf
>>
>> There, the datasheet specifically for TDA19988 only states 0x70 and
>> 0x34 as the two i2c addresses. Therefore, TDA19988 has fixed i2c
>> addresses while TDA9983b has configurable (main) i2c address.
>>
>> Not as easy as we thought ;)
>>
>> I suggest reword the reg property to:
>> "- reg: shall be set to the I2C address"
>>
>> and optionally list all known addresses for each TDA[1]998x in the
>> binding.
>
> Thanks for the link.
>
> OK, then, as the linux tda998x driver handles only the tda 19988 and
> 19989 chips, the HDMI I2C address is always 0x70.
>
> So, question: Russell and Sebastian, do you still want an other patch?

Up to Russell, but reg property is required for i2c slaves and should
be documented.

> Other question: the CEC address is hard-coded to 0x34 in the driver.
> Should it be configurable in the DT?

Looking at nxp's website, detailed information about TDA[1]998x have
vanished. Luckily, there are some hints in the parametric search:

There is TDA998[14] without any CEC support and
TDA1998[89] with CEC support. Both TDA19988 and TDA19989 have
fixed i2c addresses 0x70 and 0x34 respectively.

So, the answer is:

Let the driver access CEC i2c slave only if it is TDA1998[89]. The
HDMI part should be quite compatible with TDA998x, so if anyone
has it on his board, he is invited to add proper support.

For the binding, reg address should contain reg property to the
HDMI i2c slave. Add proper compatibles/i2c_ids for nxp,tda19988 and
nxp,tda19989 and check that to add the CEC i2c slave on 0x34.

If, someday there will be a tda19990 with configurable addresses,
I am sure you can derive it from i2c main address, e.g. 0x70<>0x34,
0x71<>0x35, aso.

No need to take care of configurable CEC slave address now, neither
in the driver nor binding.

Sebastian
