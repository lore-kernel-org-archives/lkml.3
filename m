Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaLSJEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:04:11 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:59103 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaLSJEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:04:06 -0500
Message-ID: <5493EA03.10004@schinagl.nl>
Date: Fri, 19 Dec 2014 10:04:03 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 0/2] Add Allwinner SoCs PWM support
References: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com> <546B4DF5.9020100@schinagl.nl> <20141217195836.GD4885@piout.net>
In-Reply-To: <20141217195836.GD4885@piout.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alexandre!

On 17-12-14 20:58, Alexandre Belloni wrote:
> Hi,
>
> I finally got some time to work on that again.
awesome :D
>
> On 18/11/2014 at 14:47:33 +0100, Olliver Schinagl wrote :
>> What I get from the datasheet is, that sun4i and sun5i are exactly the same,
>> with the exception that sun5i only has 1 PWM (~exposed~). I belive that is
>> easily solved with the bindings by having allwinner-sun4i and allwinner
>> sun5i bindings if I'm not mistaken.
>>
>> As for sun7i compared to the other ones, according to disp_lcd.c sun5i and
>> sun7i should behave exactly the same. This is contradicting to the
>> datasheet, where sun4i and sun5i are the same.
>>
>> So what are the major differences that I can see between the 3? sun4i
>> defines the PWM prescaler register value 0b1111 as being undefined, and
>> sun5i and sun7i as /1? Did you verify this (I haven't I admit, i bumped into
>> this while looking for your patch ;-) )? I wouldn't be supprised if it where
>> a typo on allwinners end in the datasheet ... disp_lcd.c stops at 72000 for
>> the last entry. We should just check sun4i, sun5i and sun7i hardware to see
>> if it behaves the same with a prescaler of 0b1111, which I would not be
>> totally surprised if it did.
>>
>> The other difference I notice is that sun7i and sun5i use 16bit period
>> register where sun4i uses a 8bit register. This is probably the only reason
>> why they put a #ifdef in disp_lcd.c, calculations turn out differently. I
>> don't recognize this behavior at all in your driver however. I do think they
>> that there is a difference here, since they did split up the original driver
>> here because of this difference.
>>
> That is something I overlooked and I can't test at all, I only have a
> cubietruck. Did you have some time to test on a sun4i?
I have sun4i, sun5i and sun7i to test this on; though my sun5i is a 
tablet so needs some work to setup as a dev environment (solder uart 
etc). On sun7i the pwm worked perfectly; I will find some time to test 
in on sun4i and sun5i in the next few weeks with your v10 patches
>
> But, from the only datasheet I have access to [1], page 56:
> Each channel has a dedicated internal 16-bit up counter. If the counter
> reaches the value stored in the channel period register, it resets. At
> the beginning of a count period cycle, the PWMOUT is set to active state
> and count from 0x0000
>
> So I would say that they all have a 16bits period.
>
>
> [1] http://dl.linux-sunxi.org/A10/A10%20Datasheet%20-%20v1.21%20%282012-04-06%29.pdf
yeah we only have the datasheets available on dl.linux-sunxi.org; but 
don't only rely on the datasheets, it's a horrid copy/paste mess that 
may be very wrong due to lazy editing of the pastes :(

The sorucecode helps a bit in this, as pwm0 is always used as a 
background light driver, so should atleast be somewhat verified to work.

Olliver
>

