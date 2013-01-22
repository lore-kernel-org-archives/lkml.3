Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3AVJhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:37:32 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:56548 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3AVJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130122093214.GK16143@arwen.pp.htv.fi>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
	<053c01cdf860$9e98df20$dbca9d60$@samsung.com>
	<20130122085004.GD16143@arwen.pp.htv.fi>
	<CAFp+6iEoCF91HiDbixqsKX5XS_UQrN=+2O7puPqN1MvjY_eHBg@mail.gmail.com>
	<20130122092947.GJ16143@arwen.pp.htv.fi>
	<20130122093214.GK16143@arwen.pp.htv.fi>
Date: Tue, 22 Jan 2013 15:07:25 +0530
Message-ID: <CAFp+6iGEZMKv+6QvrdfZ1z5o0QGzunxyxiJL_8YjnyGr0pJTKw@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com,
        cpgs@samsung.com, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Tue, Jan 22, 2013 at 3:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> HI,
>
> On Tue, Jan 22, 2013 at 11:29:47AM +0200, Felipe Balbi wrote:
>> On Tue, Jan 22, 2013 at 02:45:26PM +0530, Vivek Gautam wrote:
>> > Hi Felipe,
>> >
>> >
>> > On Tue, Jan 22, 2013 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > > HI,
>> > >
>> > > On Mon, Jan 21, 2013 at 09:23:28PM -0800, Kukjin Kim wrote:
>> > >> Vivek Gautam wrote:
>> > >> >
>> > >> > Changes from v5:
>> > >> >  - Rebased on top of latest patches:
>> > >> >         usb: phy: samsung: Introducing usb phy driver for hsotg (v9)
>> > >> >         usb: phy: samsung: Add support to set pmu isolation (v6)
>> > >> >    As a result adding hostphy enable mask and hostphy register offsets
>> > >> >    to driver data in order to access the HOSTPHY CONTROL register.
>> > >> >
>> > >> >  - Adding member 'otg' to struct samsung-usbphy so that its consumers
>> > >> >    can call otg->set_host so as to make 'phy' aware of the consumer type:
>> > >> >     HOST/DEVICE
>> > >> >
>> > >> >  - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
>> > >> >    which keeps track of 'otg' of the controllers' phy. This then sets
>> > >> >    the host.
>> > >> >
>> > >> >  - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exynos
>> > >> >    to phy driver itself where based on phy_type it is called.
>> > >> >
>> > >> >  - Added separate macro definition for USB20PHY_CFG register to select
>> > >> >    between host/device type usb link.
>> > >> >
>> > >> >  - Removing unnecessary argument 'phy_type' from
>> > >> > samsung_usbphy_set_type()
>> > >> >    and samsung_usbphy_cfg_sel().
>> > >> >
>> > >> >  - Addressed few nits:
>> > >> >     -- added macro for 'KHZ'
>> > >> >     -- removing useless 'if' from samsung_usbphy_cfg_sel()
>> > >> >     -- keeping the place of clk_get intact and requesting driver
>> > >> >        data before that.
>> > >> >
>> > >> > Vivek Gautam (4):
>> > >> >   ARM: EXYNOS: Update & move usb-phy types to generic include layer
>> > >> >   usb: phy: samsung: Add host phy support to samsung-phy driver
>> > >> >   USB: ehci-s5p: Add phy driver support
>> > >> >   USB: ohci-exynos: Add phy driver support
>> > >> >
>> > >> >  .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
>> > >> >  drivers/usb/host/ehci-s5p.c                        |   81 +++-
>> > >> >  drivers/usb/host/ohci-exynos.c                     |   85 +++-
>> > >> >  drivers/usb/phy/Kconfig                            |    2 +-
>> > >> >  drivers/usb/phy/samsung-usbphy.c                   |  512
>> > >> ++++++++++++++++++--
>> > >> >  include/linux/usb/samsung_usb_phy.h                |   16 +
>> > >> >  6 files changed, 635 insertions(+), 73 deletions(-)
>> > >> >  create mode 100644 include/linux/usb/samsung_usb_phy.h
>> > >> >
>> > >> > --
>> > >> > 1.7.6.5
>> > >>
>> > >> Looks good to me,
>> > >>
>> > >> Felipe and Greg, I don't know who should take this series anyway, feel free
>> > >> to add  my ack:
>> > >>
>> > >> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> > >
>> > > I will take care of it. But I need Alan's Acked-by for EHCI and OHCI
>> > > parts.
>> > >
>> >
>> > We got Alan's ACK for:
>> > USB: ehci-s5p: Add phy driver support
>> > USB: ohci-exynos: Add phy driver support
>>
>> Ok, then as soon as I get back to the office (in a few hours), I'll
>> start queueing those.
>
> Actually, if you want to make my life a little easier today, you could
> resend the series with all Acks in place ;-)
>

Sure, will resend the patches with proper Acks and version :-)

> ps: hehe, I'm about to go a little nuts today, too many things happening
> at once ;-)
>
:-)


-- 
Thanks & Regards
Vivek
