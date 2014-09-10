Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIJNzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:55:15 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33988 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaIJNzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140821140040.GE9608@saruman.home>
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com>
	<31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl>
	<53F31F52.8060904@zonque.org>
	<CALHRZur5BC8Q2WFghU8jAtXzt1=tm=8swxp2xEz3MV4z5CCE9A@mail.gmail.com>
	<20140821140040.GE9608@saruman.home>
Date: Wed, 10 Sep 2014 19:25:11 +0530
Message-ID: <CALHRZuqt-XJ5mPczzGJtSN=iq7TPut0=54r90QHWR+w-Lwwtyg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: Daniel Mack <daniel@zonque.org>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        svemula@xilinx.com, anirudh@xilinx.com,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Aug 21, 2014 at 7:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Aug 21, 2014 at 12:19:03PM +0530, sundeep subbaraya wrote:
>> Hi Daniel,
>>
>> On Tue, Aug 19, 2014 at 3:26 PM, Daniel Mack <daniel@zonque.org> wrote:
>> > Hi,
>> >
>> > On 07/22/2014 11:08 AM, Subbaraya Sundeep Bhatta wrote:
>> >> This patch adds xilinx usb2 device driver support
>> >
>> > Add some more information here, please. Copying the text from the
>> > Kconfig option is already a good start.
>> >
>> >>  drivers/usb/gadget/Kconfig      |   14 +
>> >>  drivers/usb/gadget/Makefile     |    1 +
>> >>  drivers/usb/gadget/udc-xilinx.c | 2261 +++++++++++++++++++++++++++++++++++++++
>> >>  3 files changed, 2276 insertions(+), 0 deletions(-)
>> >>  create mode 100644 drivers/usb/gadget/udc-xilinx.c
>> >
>> > As your driver has a DT binding, you have to describe it in
>> > Documentation/devicetree/bindings.
>> >
>> >> --- a/drivers/usb/gadget/Kconfig
>> >> +++ b/drivers/usb/gadget/Kconfig
>> >> @@ -459,6 +459,20 @@ config USB_EG20T
>> >>         ML7213/ML7831 is companion chip for Intel Atom E6xx series.
>> >>         ML7213/ML7831 is completely compatible for Intel EG20T PCH.
>> >>
>> >> +config USB_GADGET_XILINX
>> >> +     tristate "Xilinx USB Driver"
>> >> +     depends on COMPILE_TEST
>> >
>> > Why would you depend on that?
>>
>> Felipe asked to make this since this is USB soft IP driver and its
>> dependencies have tendency to grow.
>
> that's not exactly what I asked :-) Usually you only add COMPILE_TEST
> when you have an ARCH dependency. So something like:
>
>         depends on ARCH_ARM || COMPILE_TEST
>
> would make it clear that this driver is only available on ARM, but when
> doing my build tests, I'd still be able to compile it on x86.

Ok got it :)
>
>> > Also, your code uses device tree functions unconditionally, which is
>> > fine, but it must hence depend on 'OF'.
>>
>> Ok will add OF along with COMPILE_TEST
>
> so this would be:
>
>         depends on OF || COMPILE_TEST
Ok

Thanks,
Sundeep

>
> --
> balbi
