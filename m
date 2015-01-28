Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbbA2Cdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:33:39 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43485 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbbA2Cde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <20150128095401.GC14175@tarshish>
References: <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<20150128061250.GQ2555@sapphire.tkos.co.il>
	<CAAfSe-v4FGpHL3N3utiDwcoc7qus1XZZszuXBqB6LeE1frAfeA@mail.gmail.com>
	<20150128095401.GC14175@tarshish>
Date: Wed, 28 Jan 2015 18:46:53 +0800
Message-ID: <CAAfSe-t-to3=KrUH2cWQXy710H8Lr3Nd7Za1yoaxio4i70c51w@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>, "jslaby@suse.cz" <jslaby@suse.cz>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Hayato Suzuki <hytszk@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 5:54 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi Lyra Zhang,
>
> On Wed, Jan 28, 2015 at 04:46:33PM +0800, Lyra Zhang wrote:
>> On Wed, Jan 28, 2015 at 2:12 PM, Baruch Siach <baruch@tkos.co.il> wrote:
>> > On Wed, Jan 28, 2015 at 10:47:41AM +0800, Chunyan Zhang wrote:
>> >> +             if (uart_handle_sysrq_char(port, ch))
>> >> +                     continue;
>> >
>> > My comment[1] on a previous version of this patch still stands.
>> > uart_handle_sysrq_char is a NOP when SUPPORT_SYSRQ is not defined.
>>
>> yes, there are two definitions in serial_core.h, and it returns 0 when
>> SUPPORT_SYSRQ is not defined.
>> so, I think my code behavior does not hurt, right?
>
> Right. I just wanted to point out that you can easily define SUPPORT_SYSRQ as
> appropriate like many other serial drivers do to get sysrq support.
>

Ok, I got it. I'll add SUPPORT_SYSRQ definition, and send v10 to Greg.

thanks,
Chunyan

> baruch
>
> --
>      http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
