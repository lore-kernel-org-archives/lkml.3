Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3H2Om3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:42:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48378 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3H2Om1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <81053150.gZpPo7ioCr@avalon>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
	<4590364.P8qlcBVRgM@avalon>
	<20130828074126.GD10210@lee--X1>
	<81053150.gZpPo7ioCr@avalon>
Date: Thu, 29 Aug 2013 07:42:26 -0700
Message-ID: <CAGa+x87xcVBxc7_AV8mmGq8DWuhgA3EL6jiwqQD33terH4XPBg@mail.gmail.com>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
From: Kevin Hilman <khilman@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Lee Jones <lee.jones@linaro.org>, Chris Ball <cjb@laptop.org>,
        Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:51 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Lee,
>
> (Dropping Ian Molton <ian.molton@collabora.co.uk> from the CC list as the e-
> mail address isn't valid anymore)
>
> On Wednesday 28 August 2013 08:41:26 Lee Jones wrote:
>> > > Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
>> > > platform data", .set_pwr() callback is removed from platform data.
>> > > Thus, .set_pwr() is not used anymore. Also, this patch fixes
>> > > the following build error and warning.
>> > >
>> > > drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in
>> > > initializer drivers/mfd/asic3.c:724:2: warning: initialization makes
>> > > integer from pointer without a cast [enabled by default]
>> > > drivers/mfd/asic3.c:724:2: warning: (near initialization for
>> > > 'asic3_mmc_data.capabilities' [enabled by default]
>> >
>> > My bad, it looks like I've overlooked a few users of the .set_pwr() field
>> > :-/ Sorry about that.
>>
>> <snip>
>>
>> > I don't think blindly removing the function is the right fix, as it seems
>> > to be needed. Looking at the whole series, I believe we should just
>> > revert 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from platform
>> > data" instead.
>>
>> No need to revert it, as it's not in Mainline yet. Just request for it
>> to be removed from Chris' tree.
>
> I spupose it depends on whether Chris has provided a stable branch with the
> patch included. I'm fine with both, the commit just needs to be undone one way
> or another.

Any progress on this?  linux-next builds are still failing for the
following defconfigs because of this removal:

Failed defconfigs:
        arm-magician_defconfig
        arm-eseries_pxa_defconfig

Errors:

         arm-magician_defconfig
drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in
initializer

        arm-eseries_pxa_defconfig
drivers/mfd/t7l66xb.c:146:2: error: unknown field 'set_pwr' specified
in initializer
drivers/mfd/tc6387xb.c:123:2: error: unknown field 'set_pwr' specified
in initializer
drivers/mfd/tc6393xb.c:381:2: error: unknown field 'set_pwr' specified
in initializer

Kevin
