Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaIIK1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61378 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaIIK1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140909093606.GB2974@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
	<1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
	<20140905153835.GC13242@localhost>
	<CAE1zotK4QkA9PWW=uOmM-j=N=MNuBt1v3CgdA+GXctdFUZ3QKA@mail.gmail.com>
	<20140909093606.GB2974@localhost>
Date: Tue, 9 Sep 2014 13:27:01 +0300
Message-ID: <CAE1zotJ8rZTvtSoWAz+upAo64OxWVMGRj-Bivy5QFv57cQ8bJw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:36 PM, Johan Hovold <johan@kernel.org> wrote:
> On Fri, Sep 05, 2014 at 07:04:51PM +0300, Octavian Purdila wrote:
>> On Fri, Sep 5, 2014 at 6:38 PM, Johan Hovold <johan@kernel.org> wrote:
>> > On Fri, Sep 05, 2014 at 06:17:59PM +0300, Octavian Purdila wrote:
>
>> > In general, how well have these patches been tested with disconnect
>> > events? At least gpiolib is known to blow up (sooner or later) when a
>> > gpiochip is removed when having requested gpios.
>>
>> I do disconnect tests regularly. Since switching to the new irq
>> interface the following patch is needed:
>>
>> https://lkml.org/lkml/2014/9/5/408
>>
>> With it and the current patch sets things seems to work well.
>
> I see no comments from Linus W on that patch?
>
> And I can confirm that things do blow up.
>
> After disconnecting while having a gpio exported, I get the familiar
> OOPS below when reconnecting the device.
>
> This has also been reported here:
>
>         https://lkml.org/lkml/2014/8/4/303
>

Hi Johan,

I did not test with gpio exported via sysfs, only with an i2c driver
that requests a gpio irq. That works because when the i2c bus gets
removed the i2c device gets removed as well and that drops the
requested irq which frees the gpio.

I do see your point with exporting a gpio via sysfs. So I will drop
the remove retry from the patch.

However, I think the above mentioned patch is worth merging as it is
simple enough and it fixes a couple of issues in the gpio remove path.
But I guess we can discuss this in that thread, when Linus W gets to
it.

And thanks a lot for spending so much time on reviewing these patches.
