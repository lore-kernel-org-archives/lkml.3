Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3FJPyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:54:23 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:49824 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab3FJPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:54:20 -0400
Message-ID: <51B5F60D.6050205@st.com>
Date: Mon, 10 Jun 2013 16:51:41 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 04/11] mfd:stixxxx-syscfg: Add ST System Configuration
 support.
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <CACRpkdaW2ALTWCB7Rd8m=aAGQwh3T_dJVncxJn_eXer4X3J6_g@mail.gmail.com> <51B5DA26.6070707@st.com> <2757224.FBxg98dX57@wuerfel>
In-Reply-To: <2757224.FBxg98dX57@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments.
On 10/06/13 15:02, Arnd Bergmann wrote:
> On Monday 10 June 2013 14:52:38 Srinivas KANDAGATLA wrote:
>> On 10/06/13 14:16, Linus Walleij wrote:
>>> On Mon, Jun 10, 2013 at 11:22 AM, Srinivas KANDAGATLA
>>> <srinivas.kandagatla@st.com> wrote:
>>>
>>>> This mfd driver provides higher level inialization routines for various
>>>> IPs like Ethernet, USB, PCIE, SATA and so on. Also it provides way to
>>>> get to syscfg registers via standard regmap api which is usefull for
>>>> drivers like pinctrl.
>>>>
>>>> This patch adds support to ST System Configuration registers, which can
>>>> be configured by the drivers.
>>>>
>>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>>> CC: Stuart Menefy <stuart.menefy@st.com>
>>>> CC: Stephen Gallimore <stephen.gallimore@st.com>
>>>> CC: Linus Walleij <linus.walleij@linaro.org>
>>>> CC: Mark Brown <broonie@kernel.org>
>>>
>>> What is this driver doing that drivers/mfd/syscon.c is not already
>>> doing?
>>
>> As of now, the driver is very much similar to syscon + some additional
>> functionality, but we are planning to use this file to add higher level
>> functions to configure different IPs like ethernet, usb, power, reset
>> and so on which are very much specific to ST System Configuration Registers.
> 
> I was expecting that you'd actually interface with the syscon code and
> build on top, rather than copy it.
> 
I did not like the copying either, on the other hand I don't want to
pollute the syscon code.

As you said, I will make use of existing syscon and build "System
configuration interface" on top of it and see how it look like. It will
definitely get rid of lot of code duplication.

Thanks,
srini

> There are multiple ways of doing that, e.g. you could export a function
> from syscon.c that you call to register the device node and then import
> the regmap from syscon into your high-level driver again.

> 
> 	Arnd
> 
> 

