Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaESUmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:42:08 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46381 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaESUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <1400531394.14238.35.camel@joe-AO725>
References: <Pine.LNX.4.44L0.1405191615451.1538-100000@iolanthe.rowland.org> <1400531394.14238.35.camel@joe-AO725>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 22:41:45 +0200
Message-ID: <CAPybu_0_3-a_O8o8P478vupRB44u9jz+cmrQi35jifb6StCn9g@mail.gmail.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
To: Joe Perches <joe@perches.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good idea.

 I am going to define ep_* and use them.

btw, DEBUG cannot be used if not unset, because there is a namespace collision.

Regards!



On Mon, May 19, 2014 at 10:29 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-05-19 at 16:17 -0400, Alan Stern wrote:
>> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
>> > I really think that setting/unsetting DEBUG and VERBOSE is not a good
>> > idea, and the generic functions are there to be used.
>> You could change the definitions of DEBUG and VDEBUG to make them use
>> the generic functions.
>> > What do you think that makes it more difficult to read? The GETDEV macro?
>
> Maybe add ep_<level> helper macros and remove xprint
>
> #define ep_err(ep, fmt, ...)                                    \
>         dev_err(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
> #define ep_warn(ep, fmt, ...)                                   \
>         dev_warn(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
> #define ep_info(ep, fmt, ...)                                   \
>         dev_info(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
> #define ep_dbg(ep, fmt, ...)                                    \
>         dev_dbg(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
> #define ep_vdbg(ep, fmt, ...)                                   \
>         dev_vdbg(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
>
> but even that conversion isn't straightforward.
>
>



-- 
Ricardo Ribalda
