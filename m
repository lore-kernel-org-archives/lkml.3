Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3GLL4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:56:50 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49592 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3GLL4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <4066449.W80oPjbVFF@avalon>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
	<20130712110047.GA3135@katana>
	<CAHp75Ve8oLeT=-_t96i_ctcmnM4kEPHD0cBjBroJTnYxwczBmw@mail.gmail.com>
	<4066449.W80oPjbVFF@avalon>
Date: Fri, 12 Jul 2013 14:56:47 +0300
Message-ID: <CAHp75Vfzo=Co2EV04ihxF1c6f203iu=2WF6sih8_BNTJ50ngUg@mail.gmail.com>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Bin Gao <bin.gao@linux.intel.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 2:35 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 12 July 2013 14:29:16 Andy Shevchenko wrote:
>> On Fri, Jul 12, 2013 at 2:00 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> >> Briefly looking into ACPI tables we have and mechanisms that we can
>> >> use in ACPI case, I doubt we may apply all the ideas, probably some of
>> >> them, though I didn't get yet where to read about in details. What I
>> >> could say now is that the patch provided by Bin Gao is definitely no
>> >> go.
>> >
>> > Laurent explained to me what V4L did and now does. It used to be the way
>> > tha V4L drivers did register I2C slaves according to platform_data. Now,
>> > with DT the slaves get instanciated earlier, so they now use notifiers
>> > to know when the slaves are in place. Something like this should
>> > probably be done here, too, instead of unregistering and re-registering.
>>
>> Yes, seems right way to go.
>> I think ACPI case can use V4L2 async API somehow, though it has its
>> own event model.
>> I'll talk to Sakari Ailus to sync.
>
> Do you have any pointer to the relevant parts of the ACPI specification ?

Section 5.6.6 of ACPI5 spec describes device object notifications.
It's useful to detect hotplug events.

Otherwise, the i2c slave devices are enumerated from the i2c host
controller (for example, you can look at i2c-designware-platdrv.c:176.
It's done in a very similar way like for DT case.

However, it's possible to have i2c slaves described as children of
camera device in the DSDT (analogue of the DT). In that case camera
driver (v4l2 framework?) shall enumerate them on its own.

--
With Best Regards,
Andy Shevchenko
