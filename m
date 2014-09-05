Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaIEH6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:58:40 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41609 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaIEH6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <CANjd3nc5==yDpRVMxP+bzhqhEqyK4SUam=Ood4RMpsN5esuG4A@mail.gmail.com>
References: <20140831152456.GA25207@udknight>
	<20140904173521.GA20343@localhost.localdomain>
	<CANjd3nc5==yDpRVMxP+bzhqhEqyK4SUam=Ood4RMpsN5esuG4A@mail.gmail.com>
Date: Fri, 5 Sep 2014 09:58:38 +0200
Message-ID: <CACRpkdbkh10brE0Qy4mGFMxwWDLCiYRYB+i-5QTABxO9jcDyfA@mail.gmail.com>
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
From: Linus Walleij <linus.walleij@linaro.org>
To: zoobab@gmail.com
Cc: Wang YanQing <udknight@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>, andi@lisas.de, dforsi@gmail.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:57 PM, Benjamin Henrion <zoobab@gmail.com> wrote:
> On Thu, Sep 4, 2014 at 7:35 PM, Wang YanQing <udknight@gmail.com> wrote:
>> On Sun, Aug 31, 2014 at 11:24:56PM +0800, Wang YanQing wrote:
>>> PL2303 USB Serial devices may has GPIOs, this patch add
>>> basic PL2303 gpio support.
>>>
>>> Known issue:
>>> If gpios are in use(export to userspace through sysfs interface, etc),
>>> then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
>>> will cause trouble, so we need to make sure there is no gpio user before
>>> call pl2303_release.
>>>
>>> Signed-off-by: Wang YanQing <udknight@gmail.com>
>>> ---
>>>  Note: I sniffed office HXD gpio test program to get
>>>        gpios control protocol with PL2303 RA, so I only
>>>        test it with PL2303 RA and HXA, I don't have HXD,
>>>        but because it is *office* HXD gpio test program,
>>>        so if it doesn't work with HXD, I will feel surprise.
>
> I can confirm your patch is working fine on the HXD:
>
> http://www.zoobab.com/pl2303hxd-gpio
>
> I am still hunting for a simple C program to test the speed of the
> GPIOs and sysfs, if you have a good reference.

The exercise of the GPIO sysfs interface should be discouraged.
I would put emphasis on in-kernel tests and working on a better
userspace GPIO interface than the sysfs thing.

Yours,
Linus Walleij
