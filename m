Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaDVDfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:35:36 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35200 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaDVDfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <001101cf5dd1$2e04d390$8a0e7ab0$%han@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
	<534529B2.2020107@samsung.com>
	<CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
	<53454C11.7060607@samsung.com>
	<CAFp+6iHU0YXj18ajDwOqPh_SJWr6GkMPRr6qaGdmPoCc0+tz5g@mail.gmail.com>
	<CAFp+6iH7-O8pNNMrk7Yhg1u+DXcXD1Tp9RYdiFg+-Om5Toojfw@mail.gmail.com>
	<534E892B.6090409@samsung.com>
	<CAFp+6iGYfz+ZT9zxgeVefLhtb0mb-=K4faUZC+1FtQoO0hMoqw@mail.gmail.com>
	<001101cf5dd1$2e04d390$8a0e7ab0$%han@samsung.com>
Date: Tue, 22 Apr 2014 09:05:07 +0530
X-Google-Sender-Auth: wF1dxK3SNKtkQXXXbiZ208Y-_EQ
Message-ID: <CAFp+6iHvFtMbzr1NG7J_DS5upzhgaKOiuKTk_9cUNpfLswbJyQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,


On Tue, Apr 22, 2014 at 7:48 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Wednesday, April 16, 2014 11:49 PM, Vivek Gautam wrote:
>> On Wed, Apr 16, 2014 at 7:14 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> > On 15.04.2014 08:09, Vivek Gautam wrote:
>> >> On Thu, Apr 10, 2014 at 5:09 PM, Vivek Gautam wrote:
>> >>> On Wed, Apr 9, 2014 at 7:03 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> >>>> On 09.04.2014 13:49, Vivek Gautam wrote:
>> >>>
>> >>> So, USB30_SCLK_100M is the SCLK that we are talking in the driver. I
>> >>> don't see any reference to XXTI in the USB 3.0 DRD controller chapter
>> >>> (in both Exynos5250 and 5420)
>> >>> In addition to this there's one more point to be noticed here.
>> >>> On Exynos5420 system, the sclk_usbphy300 (which is the sclk_usbphy30
>> >>> for USB DRD channel 0), is also the PICO phy clock, i.e. USB 2.0 phy
>> >>> clock.
>> >>> So we should add a similar clk_get() for this clock in the
>> >>> phy-exynos5250-usb2 driver too, to support Exynos5420.
>> >>
>> >>
>> >> Is something clear from the above block diagram ? (although the
>> >> diagram looks weird - space and tabs problem :-(  )
>> >> Basically there's the clock USB30_SCLK_100M which is going into the
>> >> USB 3.0 DRD PHY controller.
>> >> And this is the only sclk mentioned in the block diagram for USB 3.0
>> >> DRD controller in Exynos5420.
>> >> Same is not there in the block diagram in Exynos5250 UM.
>> >
>> >
>> > From what I can see in the documentation, there are 4 USB 3.0 related clocks
>> > generated in CMU:
>> >
>> >  - sclk_usbphy300,
>> >  - sclk_usbphy301,
>> >  - sclk_usbdrd300,
>> >  - sclk_usbdrd301,
>> >
>> > They are all rated to max. 24 MHz and the recommended operating frequency is
>> > 24 MHz, so it looks exactly like USB PHY reference, which is usually a 24
>> > MHz clock.
>> >
>> > To me, this looks like on Exynos5420 a separate special clock path is used
>> > instead of xusbxti as reference of USB 3.0 PHY and so the sclk should be
>> > simply passed as the "ref" clock.
>>
>> Ok, i will clear on this with the hardware engineer also once.
>> May be Jingoo can help me with this.
>>
>> Jingoo,
>> Can you please enquire about the clock path of usbphy30 reference
>> clocks on Exynos5420.
>> As mentioned by Tomasz above, we have sclk_usbphy300 and
>> sclk_usbphy301 as the reference clocks for USB3.0 DRD phy. *Also*
>> sclk_usbphy300 is used for Pico phy (which is the USb 2.0 phy used by
>> ehci/ohci controller on Exynos5420).
>> It will be of great help.
>
> Hi Vevek, Tomasz
>
> Long time no see.
>
> I asked USB S/W engineer and USB H/W engineer.
>
> There are two USB3.0 on Exynos5420; thus there are two sclks
> such as 'sclk_usbphy300 and sclk_usbphy301'.
>
> As Tomasz mentioned, 'sclk_usbphy300 and sclk_usbphy301' can
> be used instead of 'xusbxti' as reference of USB 3.0 PHY.

Thank you so much for getting this information.
I can re-spin the patch. :-)

>
> However, on Exynos5420, "ONLY" 'sclk_usbphy300' can be used
> for USB2.0 pico phy. (so, '301' CANNOT support USB2.0 pico phy.)

True, for USB 2.0 pico phy, only sclk_usbphy300 can be used.
