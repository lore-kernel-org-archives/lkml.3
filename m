Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbaJUNen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:34:43 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34523 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbaJUNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <20141021132630.79ce15ba@alan.etchedpixels.co.uk>
References: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141018220615.33643542@alan.etchedpixels.co.uk>
	<CA+H2tpH2dKFHxHUaGtr-vEqxZDtQ_MVTmQTnu5kn-zzUFyXk4Q@mail.gmail.com>
	<20141021132630.79ce15ba@alan.etchedpixels.co.uk>
Date: Tue, 21 Oct 2014 21:34:41 +0800
Message-ID: <CA+H2tpGJuukXZuGwysa5Y6LvjgZj3TVDWfngpM67p3nfzdi0YQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
From: Orson Zhai <orsonzhai@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?R2VuZyBSZW4gKCDku7votZMp?= <geng.ren@spreadtrum.com>,
        =?UTF-8?B?WmhpemhvdSBaaGFuZyAoIOW8oOayu+a0sik=?= 
	<zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sprdlinux <sprdlinux@freelists.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 8:26 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Mon, 20 Oct 2014 18:23:38 +0800
> Orson Zhai <orsonzhai@gmail.com> wrote:
>
>> On Sun, Oct 19, 2014 at 5:06 AM, One Thousand Gnomes
>> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> > On Fri, 17 Oct 2014 17:54:25 +0800
>> > Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:
>> >
>> >> Add serial driver for spreadtrum sharkl platform with earlycon
>> >> support at first.
>> >
>> >> +#define UART_TXD     0x0000
>> >> +#define UART_RXD     0x0004
>> >> +#define UART_STS0    0x0008
>> >> +#define UART_STS1    0x000C
>> >> +#define UART_IEN     0x0010
>> >> +#define UART_ICLR    0x0014
>> >> +#define UART_CTL0    0x0018
>> >> +#define UART_CTL1    0x001C
>> >> +#define UART_CTL2    0x0020
>> >> +#define UART_CLKD0   0x0024
>> >> +#define UART_CLKD1   0x0028
>> >> +#define UART_STS2    0x002C
>> >> +
>> >> +/*line status */
>> >> +#define UART_LSR_TX_OVER     (0x1<<15)
>> >
>> > Given we use UART_ for all the 8250 defines it might be better to use
>> > something else - SHARK_LSR_TX_OVER etc to avoid future confusion
>> >
>>
>> Does it matter if those macro are only used in the specific c file?
>> >From my point of  view, private register macro could be treated as
>> static definitions like static variable or functions in C file.
>> I also noted that many people use a prefix for the other
>> manufacturers' macro definition in source file .
>> I have no intention to break the habit of kernel but just for discussion.
>
> Your problem is this. In the kernel headers are definitions like
>
> include/uapi/linux/serial_reg.h:#define UART_TX 0       /* Out: Transmit
> buffer */
>
> you are adding identical (but conflicting in places) defines. If some
> random change in the include files causes serial_reg.h to be included by
> a header you include then it will break.
>
> In addition people habitually use tools like LXR to figure out where
> defines and functions are.

This make much more sense, thanks for you explanation.

> Having these conflicting definitions will
> cause confusion. Better they have prefixes.
>
> Alan
>
