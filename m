Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3LJUCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:02:41 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61733 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LJUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:02:39 -0500
Message-ID: <52A77358.5070602@gmail.com>
Date: Tue, 10 Dec 2013 21:02:32 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] ARM: Initial support for Marvell Berlin SoCs
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com> <52A674F1.7000104@gmail.com> <20131210191653.GA10105@quad.lixom.net> <201312102033.00953.arnd@arndb.de> <CAOesGMhMAC56AK5YwA2ROzQ5b6HuWXzF31HDCyx7fYzka6WvHQ@mail.gmail.com>
In-Reply-To: <CAOesGMhMAC56AK5YwA2ROzQ5b6HuWXzF31HDCyx7fYzka6WvHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:38 PM, Olof Johansson wrote:
> On Tue, Dec 10, 2013 at 11:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 10 December 2013, Olof Johansson wrote:
>>>> I started with mach-mvebu in the first RFC, but Berlin SoCs are from a
>>>> different business unit at Marvell and are more PXA compatible than
>>>> Orion/Kirkwood/Armada 370/XP. Most notably, they lack the "mbus" and
>>>> IP is either from PXA/MMP or Synopsys DW. Thomas Petazzoni and also
>>>> Jisheng Zhang from Marvell suggested to not put it into mvebu but
>>>> have a different mach folder instead.
>>>
>>> Hmm, ok. Well, maybe later on we can look at aggregating them more again. It'd
>>> be nice to get fewer top-level platform directories per vendor.
>>
>> I possibly a lot of directories just become empty in the long run and
>> we remove them once all all code has been subsystemized and drivered.
>
> For mobile SoCs it's somewhat unlikely that it will ever be completely
> empty, but maybe. Either way, once the contents is small enough it's a
> lot easier to move around and aggregate into one platform.

Well, I plan to add no code at all to mach-berlin except machine init.
If there would be some mach-multiv7, I'd be happy to put it in there.

mach-mvebu is still a moving target and adding it there would cause more
trouble than it helps. Adding the other Orion SoCs will be enough for
now.

About the dts/dtsi naming, I really have no preference. I had
soc-vendor-boardname style before v4. About the new naming, I liked
that SoC dtsi are named after soc-vendor,soc-type.dtsi while boards are
named after board-vendor,board-name.dts. It kind of matches what you
will look for if you have e.g. the Google Chromecast and not know about
the Soc used.

We still have some time before the ARM merge window for 3.14 closes,
right? So I can have another round of code moving and renaming within
this patch set ;)

Sebastian
