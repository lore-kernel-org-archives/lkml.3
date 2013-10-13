Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3JMBfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 21:35:00 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62017 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3JMBe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 21:34:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131012175034.GA3858@kroah.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
	<20131011153544.GA14715@kroah.com>
	<CABawtvP+BqpwGYJpvBVbEUyqptSWoF0YEGqbT6o+aTP2326+7A@mail.gmail.com>
	<20131012175034.GA3858@kroah.com>
Date: Sun, 13 Oct 2013 09:34:57 +0800
Message-ID: <CABawtvNbiLXWcoP+RJUkxzXdECmSubwfhcMazrvJTrAytFs0tg@mail.gmail.com>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming messages.
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 1:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Oct 12, 2013 at 02:52:51PM +0800, Ethan Zhao wrote:
>> >> --- a/drivers/base/core.c
>> >> +++ b/drivers/base/core.c
>> >> @@ -1904,8 +1904,7 @@ int device_rename(struct device *dev, const char *new_name)
>> >>       if (!dev)
>> >>               return -EINVAL;
>> >>
>> >> -     pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
>> >> -              __func__, new_name);
>> >> +     dev_info(dev, "'%s' renaming to '%s'\n", dev_name(dev), new_name);
>> >
>> > How about:
>> >         dev_dbg(dev, "renaming to '%s'\n", new_name);
>>
>> If something confusing or wrong, need to take a look.
>> For pr_debug(), We have to build and load a debug kernel…
>> For dev_dbg(),  We have to rebuild a kernel with CONFIG_DYNAMIC_DEBUG
>> set to 'y', that is default 'n'.
>
> Why would you not enable that option these days?  All distros enable it,
> and if you should too :)
>
Okey, let them enable it in the Linux distribution.

Thanks,
Ethan

>> So, do you mean
>>
>> dev_printk(KERN_DEBUG, dev, "renaming to '%s'\n", new_name);  ?
>
> No, dev_dbg();.
>
> thanks,
>
> greg k-h
