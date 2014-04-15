Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaDOLCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:02:33 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:62595 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaDOLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:02:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140415093305.GE8753@valkosipuli.retiisi.org.uk>
References: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
	<20140415093305.GE8753@valkosipuli.retiisi.org.uk>
Date: Tue, 15 Apr 2014 19:54:43 +0900
Message-ID: <CAHb8M2CECG7ydo9L2u5BOcQeq8V3=ydy149kCLkoueo+HbD6fg@mail.gmail.com>
Subject: Re: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: m.chehab@samsung.com, linux-dev@sensoray.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sakari

2014-04-15 18:33 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> Hi Daeseok,
>
> On Tue, Apr 15, 2014 at 01:49:34PM +0900, Daeseok Youn wrote:
>>
>> smatch says:
>>  drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
>> possible memory leak of 'dev'
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/media/usb/s2255/s2255drv.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
>> index 1d4ba2b..8aca3ef 100644
>> --- a/drivers/media/usb/s2255/s2255drv.c
>> +++ b/drivers/media/usb/s2255/s2255drv.c
>> @@ -2243,6 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
>>       dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
>>       if (dev->cmdbuf == NULL) {
>>               s2255_dev_err(&interface->dev, "out of memory\n");
>> +             kfree(dev);
>>               return -ENOMEM;
>>       }
>>
>
> The rest of the function already uses goto and labels for error handling. I
> think it'd take adding one more. dev is correctly released in other error
> cases.
I am not sure that adding a new label for error handling when
allocation for dev->cmdbuf is failed.
I think it is ok to me. :-) Because I think it is not good adding a
new label and use goto statement for this.

Thanks for review.

Regards,
Daeseok Youn.
>
> What do you think?
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
