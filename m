Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3E0EVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 00:21:54 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50380 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3E0EVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 00:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <000401ce5a75$e32ffed0$a98ffc70$@samsung.com>
References: <000401ce5a75$e32ffed0$a98ffc70$@samsung.com>
Date: Mon, 27 May 2013 09:51:51 +0530
Message-ID: <CAHdPZaNptkbUEWHKm_YWbfNgyJZwNfisGKSHHwm8BuBe+g42pQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] rtc: rtc-ds1307: use devm_*() functions
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Nikolay Balandin <nbalandin@dev.rtsoft.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 6:32 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Saturday, May 25, 2013 10:51 AM, Devendra Naga wrote:
>> On Sat, May 25, 2013 at 10:41 AM, Nikolay Balandin wrote:
>> > From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> [.....]
>
>> >
>> > -       ds1307->rtc = rtc_device_register(client->name, &client->dev,
>> > +       ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
>> >                                 &ds13xx_rtc_ops, THIS_MODULE);
>
> Hi Nikolay Baladin, Devendra Naga,
>
> Here, "devm"_rtc_device_register() is used.
> Thus, rtc_device_unregister() will be called after remove() or
> on probe failure.
>

You are correct, I am not aware of the new API that is added  by you
in c100a5e0255.

Very sorry Nikolay Baladin, I would really have seen and commented on the patch.

Thanks for letting me know. :)


>
>> >         if (IS_ERR(ds1307->rtc)) {
