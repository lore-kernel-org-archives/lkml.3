Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbbASGGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:06:03 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39786 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbbASGGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:06:00 -0500
MIME-Version: 1.0
In-Reply-To: <20150108165722.GG31926@saruman>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
	<CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
	<20141222161123.GE12815@saruman>
	<20141222161218.GF12815@saruman>
	<CALHRZuqq5Cc+WsQDzOjKOcF6HNH+OKw_7Pkkp3qssuu7kpSeLw@mail.gmail.com>
	<20150108165722.GG31926@saruman>
Date: Mon, 19 Jan 2015 11:35:58 +0530
Message-ID: <CALHRZupVqrcPfMVxJgKrpVSbYfHbeQgumt=7m7unhXy6YUC++A@mail.gmail.com>
Subject: Re: query on DWC3
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Jan 8, 2015 at 10:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jan 06, 2015 at 12:39:55PM +0530, sundeep subbaraya wrote:
>> >> On Sun, Dec 14, 2014 at 08:39:18AM +0530, sundeep subbaraya wrote:
>> >> > Hi Paul,
>> >> >
>> >> > As per my understanding, for BULK OUT we do queue a request with 512
>> >> > bytes length since we do not
>> >>
>> >> sometimes we _do_ know the size. In case of Mass Storage, we _know_ that
>> >> the first bulk out transfer will be 31-bytes (CBW), if we were to start
>> >> a 31-byte transfer, we would't receive anything.
>> >>
>> >> > know the length of the transfer Host is going to send. For Control OUT
>> >> > we know the length in wLength of
>> >> > Setup packet, hence I assumed there is no difference in programming
>> >> > model of Control IN and OUT.
>> >>
>> >> there is _no_ difference. It's just that it was agreed that for anything
>> >> other than control ep, the function drivers would take care of it. See
>> >> the uses of quirk_ep_out_aligned_size.
>>
>> got it..:)
>>
>> >
>> > btw, why are you reimplementing the driver when there's a perfectly good
>> > driver to use in mainline kernel ?
>>
>> I am writing a bare metal driver and it didn't work without alignment
>> check mentioned above.
>
> just make sure you don't copy GPL code into your bare metal driver,
> otherwise your bare metal driver will be GPL by definition. Also, since

I didn't copy linux code. I have gone through dwc3 driver while
writing udc-xilinx.c
and now it is helping me to understand dwc3 controller quickly.:)

> you're not using Linux at all, you should be asking support from
> Synopsys instead, not the Linux USB mailing list.

Sure will ask support from Synopsis.

Thanks,
Sundeep

>
> --
> balbi
