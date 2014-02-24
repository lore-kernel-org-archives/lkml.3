Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBXCKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:10:06 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:34575 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaBXCJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:09:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWMJFpV_uvi4mNZYc9R8qVWqQf3QGRhdPyc+hj=6XMoJw@mail.gmail.com>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
	<1392907779-22053-5-git-send-email-geert@linux-m68k.org>
	<CANqRtoQQ9cn55Ct7pva2Bo7461WbZG0=Y5f9zLwfKhyU2=QFZw@mail.gmail.com>
	<CAMuHMdWMJFpV_uvi4mNZYc9R8qVWqQf3QGRhdPyc+hj=6XMoJw@mail.gmail.com>
Date: Mon, 24 Feb 2014 11:09:50 +0900
Message-ID: <CANqRtoRLcac3x55N+VHK+n6RvcgT0v9==9mt1rhVda-zwCYTCg@mail.gmail.com>
Subject: Re: [PATCH 04/11] ARM: shmobile: lager legacy: Add MSIOF support
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Fri, Feb 21, 2014 at 1:18 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Magnus,
>
> On Thu, Feb 20, 2014 at 4:48 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>> +/* MSIOF */
>>> +static const struct resource sh_msiof0_resources[] __initconst = {
>>> +       DEFINE_RES_MEM(0xe6e20000, 0x0064),
>>> +       DEFINE_RES_IRQ(gic_spi(156)),
>>> +};
>>> +
>>> +static const struct resource sh_msiof1_resources[] __initconst = {
>>> +       DEFINE_RES_MEM(0xe6e10000, 0x0064),
>>> +       DEFINE_RES_IRQ(gic_spi(157)),
>>> +};
>>> +
>>> +static const struct resource sh_msiof2_resources[] __initconst = {
>>> +       DEFINE_RES_MEM(0xe6e00000, 0x0064),
>>> +       DEFINE_RES_IRQ(gic_spi(158)),
>>> +};
>>> +
>>> +static const struct resource sh_msiof3_resources[] __initconst = {
>>> +       DEFINE_RES_MEM(0xe6c90000, 0x0064),
>>> +       DEFINE_RES_IRQ(gic_spi(159)),
>>> +};
>>> +
>>> +static const struct sh_msiof_spi_info sh_msiof_info __initconst = {
>>> +       .rx_fifo_override       = 256,
>>> +       .num_chipselect         = 1,
>>> +};
>>> +
>>> +#define r8a7790_register_msiof(idx)                                    \
>>> +       platform_device_register_resndata(&platform_bus,                \
>>> +                               "spi_r8a7790_msiof",                    \
>>> +                               (idx+1), sh_msiof##idx##_resources,     \
>>> +                               ARRAY_SIZE(sh_msiof##idx##_resources),  \
>>> +                               &sh_msiof_info,                         \
>>> +                               sizeof(struct sh_msiof_spi_info))
>>
>> That for your efforts - it's good to see the MSIOF being integrated as
>> well! I have one comment on this legacy board integration code.
>>
>> Since only MSIOF1 is used on Lager (correct me if i'm wrong), isn't it
>> best to omit the unused resources from above? In case of DT I think it
>> makes sense to define all channels in the SoC.dtsi and let the
>> SoC-board.dts just enable the channels that are used. But in this case
>> with legacy code  I think we should keep thing simple and small and
>> just enable the bits that are used on the particular board.
>>
>> The same obviously applies to the Koelsch legacy code as well. =)
>
> Note that while all resources are present, only MSIOF1 is registered on
> Lager (MSIOF0 on Koelsch). This is similar to i2c on Koelsch, which also
> has all resources, but only registers active devices.

Ok, I understand. Thanks for brining this to my attention.

I'd like to avoid having unused resources so I'll cook up a patch to
rework that myself.

> It's your preference, though, so I can adapt if you want.

Thanks.

Please rework this patch to only register a single MSIOF channel. I
think it makes sense to only enable hardware that is being used.

Another question: How about "bus_num" and the platform device id
mapping? I'd like them to be the same if possible, but you are having
this "(idx+1)" bit in your code which I assume is to add offset for
the QSPI bus.

Regarding the PFC configuration, can you please double check that the
PIN_MAP_MUX_GROUP_DEFAULT() is in sync with the platform device id? Is
it the "bus_num" or the platform device id that is being used in case
of SPI?

Thanks!

/ magnus
