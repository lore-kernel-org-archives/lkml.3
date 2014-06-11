Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaFKHw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:52:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59399 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbaFKHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:52:55 -0400
Message-ID: <53980AD4.2080001@free-electrons.com>
Date: Wed, 11 Jun 2014 09:52:52 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com> <6454089.IP8IFVsofj@wuerfel> <20140610143604.GC7054@lukather> <13219561.hrRmVFjmAv@wuerfel>
In-Reply-To: <13219561.hrRmVFjmAv@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 10/06/2014 16:47, Arnd Bergmann wrote:
> On Tuesday 10 June 2014 16:36:04 Maxime Ripard wrote:
>> On Tue, Jun 10, 2014 at 03:54:56PM +0200, Arnd Bergmann wrote:
>>> On Tuesday 10 June 2014 15:47:16 Boris BREZILLON wrote:
>>>> +config I2C_SUN6I_P2WI
>>>> +       tristate "Allwinner sun6i internal P2WI controller"
>>>> +       depends on ARCH_SUNXI
>>>> +       help
>>>> +         If you say yes to this option, support will be included for the
>>>> +         P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
>>>> +         SOCs.
>>>> +         The P2WI looks like an SMBus controller (which supports only byte
>>>> +         accesses), except that it only supports one slave device.
>>>> +         This interface is used to connect to specific PMIC devices (like the
>>>> +         AXP221).
>>>> +
>>> Sorry for the stupid question, but why is this an i2c driver if the
>>> hardware protocol is completely different?
>> It's not completely different. It deviates, but still looks very
>> similar to i2c, and to be precise, SMBus.
>>
>> You'll have the full discussion that led to do this in i2c here:
>> http://www.spinics.net/lists/linux-i2c/msg15066.html
>>
>> Also, one significant thing to take into account is that the
>> communication with a device starts as I2C, only to switch to this
>> protocol after some initialization sequence.
> Ok, sounds good.
>
>>> I understand that a lot of devices can be driven using either spi or
>>> i2c, and we have two sets of {directories,maintainers,bus_types,...}
>>> for them. Your description sounds like this is a separate option
>>> that isn't any closer to i2c than it is to spi.
>> That's not true. It's *much* closer from I2C than it is from SPI.
> Ok.
>
>>> Would it perhaps be better to expose it only as a regmap rather than
>>> an i2c host?
>> That could be a solution, but is it a common practice to define a bus
>> adapter driver in a regmap driver?
> No, not yet.
>
> Maybe Boris can just put an explanation into the changeset description
> of the driver so other people are able to find it more easily.

You mean in my commit message ?
I thought it was already explaining the subtle differences between P2WI
and the SMBus protocols.

What would you like me to add to this explanation ?
Something about the I2C to P2WI initialization part ?

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

