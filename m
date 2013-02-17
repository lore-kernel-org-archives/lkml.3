Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3BQNS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 08:18:26 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36950 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab3BQNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 08:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130217074317.GB16632@S2101-09.ap.freescale.net>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
	<1358473200-17886-2-git-send-email-grant.likely@secretlab.ca>
	<20130217030331.GA15048@S2101-09.ap.freescale.net>
	<20130217074317.GB16632@S2101-09.ap.freescale.net>
Date: Sun, 17 Feb 2013 10:18:22 -0300
Message-ID: <CAOMZO5DD419Yy9UgRaQ+zMQsJ=mZ6dCohoG-52P8Ds8=bZ+shA@mail.gmail.com>
Subject: Re: [PATCH 2/2] of: use platform_device_add
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 4:43 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Sun, Feb 17, 2013 at 11:03:35AM +0800, Shawn Guo wrote:
>> On Fri, Jan 18, 2013 at 01:40:00AM +0000, Grant Likely wrote:
>> > This allows platform_device_add a chance to call insert_resource on all
>> > of the resources from OF. At a minimum this fills in proc/iomem and
>> > presumably makes resource tracking and conflict detection work better.
>> > However, it has the side effect of moving all OF generated platform
>> > devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
>> > break userspace because userspace is not supposed to depend on the full
>> > path (because userspace always does what it is supposed to, right?).
>> >
>> > This may cause breakage if either:
>> > 1) any two nodes in a given device tree have overlapping & staggered
>> >    regions (ie. 0x80..0xbf and 0xa0..0xdf; where one is not contained
>> >    within the other). In this case one of the devices will fail to
>> >    register and an exception will be needed in platform_device_add() to
>> >    complain but not fail.
>>
>> Grant,
>>
>> The patch introduce a regression on imx6q boot.
>
> It also breaks all of_amba_device users.
>
> of_amba_device_create() --> amba_device_add() --> request_resource()
> and fails.

Yes, correct: amba-pl011 does not register anymore after this patch,
which causes the serial console to be not functional.
