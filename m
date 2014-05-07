Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaEGEjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:39:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47479 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaEGEi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:38:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140505083856.GZ8753@valkosipuli.retiisi.org.uk>
References: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
	<20140415093305.GE8753@valkosipuli.retiisi.org.uk>
	<CAHb8M2CECG7ydo9L2u5BOcQeq8V3=ydy149kCLkoueo+HbD6fg@mail.gmail.com>
	<20140505083856.GZ8753@valkosipuli.retiisi.org.uk>
Date: Wed, 7 May 2014 13:38:58 +0900
Message-ID: <CAHb8M2D5C-w3+_gWHOnJRXnjwMhtMYKNLnQwtX3wuGXZN=heng@mail.gmail.com>
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

Hello,

2014-05-05 17:38 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> On Tue, Apr 15, 2014 at 07:54:43PM +0900, DaeSeok Youn wrote:
>> Hi, Sakari
>>
>> 2014-04-15 18:33 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
>> > Hi Daeseok,
>> >
>> > On Tue, Apr 15, 2014 at 01:49:34PM +0900, Daeseok Youn wrote:
>> >>
>> >> smatch says:
>> >>  drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
>> >> possible memory leak of 'dev'
>> >>
>> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> >> ---
>> >>  drivers/media/usb/s2255/s2255drv.c |    1 +
>> >>  1 files changed, 1 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
>> >> index 1d4ba2b..8aca3ef 100644
>> >> --- a/drivers/media/usb/s2255/s2255drv.c
>> >> +++ b/drivers/media/usb/s2255/s2255drv.c
>> >> @@ -2243,6 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
>> >>       dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
>> >>       if (dev->cmdbuf == NULL) {
>> >>               s2255_dev_err(&interface->dev, "out of memory\n");
>> >> +             kfree(dev);
>> >>               return -ENOMEM;
>> >>       }
>> >>
>> >
>> > The rest of the function already uses goto and labels for error handling. I
>> > think it'd take adding one more. dev is correctly released in other error
>> > cases.
>> I am not sure that adding a new label for error handling when
>> allocation for dev->cmdbuf is failed.
>> I think it is ok to me. :-) Because I think it is not good adding a
>> new label and use goto statement for this.
>
> I can ack this if you use the same pattern for error handling that's already
> there.
But it has a redundant kfree() call for dev->cmdbuf when it failed to
allocate, right?
If it is ok, I send this again after fixing as your comment.

Thanks.
Daeseok Youn.
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
