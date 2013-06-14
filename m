Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FNH3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:29:11 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46143 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FNH3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130611171119.GA35135@bingao-desk1.fm.intel.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
	<CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
	<20130606212620.GA13620@bingao-desk1.fm.intel.com>
	<CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
	<20130611171119.GA35135@bingao-desk1.fm.intel.com>
Date: Fri, 14 Jun 2013 10:29:09 +0300
Message-ID: <CAHp75VdZA_gouZohD1J+o9ybpXVLLQH=D7QDo9OznW93iBDZpQ@mail.gmail.com>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 8:11 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
> On Sun, Jun 09, 2013 at 10:53:35PM +0300, Andy Shevchenko wrote:
>> Please, try to avoid top posting in the future emails.
>>
>> On Fri, Jun 7, 2013 at 12:26 AM, Bin Gao <bin.gao@linux.intel.com> wrote:
>> > With v4l2, the camera sensor i2c devices are taken over by v4l2 master
>> > driver, i.e. ISP driver, and are not expected to be accessed from
>> > user sapce by ioctl. So ISP driver has to register them by itself to
>> > get all related information for further communication. Please check
>> > v4l2_i2c_new_subdev_board() in drivers/media/video/v4l2-common.c for details.
>>
>> Yes, this is legacy approach for non-DT/non-ACPI5 platforms.
>
> So what's the new approach for DT/ACPI5 platforms?

When DT or ACPI5 is enabled and used the devices are enumerated
through corresponding frameworks in the kernel automatically. So, you
get them initialized just after i2c host.

>> > The platform code can definitely disallow calling i2c_register_board_info()
>> > to register them but keep the i2c devices list and then let ISP driver register
>> > them. But, problems come when a single kernel is going to run on two platforms
>> > - one platform has ACPI5 and the other has SFI.
>>
>> You have to forget about SFI. Your ISP subdevices use plain platform
>> data anyway.
>
> Why have to forget about SFI which is supported by upstream kernel?

It doesn't matter. Second sentence above is explained why. SFI,
unfortunately, has few design flaws, that's why the information
located there is not much useful in ISP case.

>> In ACPI 5 case v4l2 framework must be extended to cover that case.
> To extend v4l2 framework is one of the options,

That is proper option.

> but this helper is also one
> option.

I think this helper doesn't align to the current workflow.

>> > The dynamic unregister and then
>> > register based on this new helper will not have dependency on firmware interface -
>> > the same platform code will work for all platforms.
>>
>> It's not a care of the ISP driver. I think you have to talk to Sakari
>> about your issues.
>
> We have to do it in the ISP driver if we want one binary kernel
> supporting multiple platforms.

What I'm talking about is not contradicting with that.

>> >> > A good example is that an ISP(Imaging Signal Processor) driver needs
>> >> > register i2c camera sensor devices via v4l2, so it has to unregister
>> >> > all i2c clients that were previously registered by calling
>> >> > i2c_register_board_info(), and then re-register.

>> >> Why do you need to re-register them at run time?

Still this question is not answered.


--
With Best Regards,
Andy Shevchenko
