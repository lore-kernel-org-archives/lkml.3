Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3KYTQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:16:42 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42357 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3KYTQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <201311242001.23126@pali>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
	<1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
	<CAOf5uwkrep0PhOn67+9PHmP2A2Jxrp9DNK3BRp9D_sYu_PYvvw@mail.gmail.com>
	<201311242001.23126@pali>
Date: Mon, 25 Nov 2013 20:16:34 +0100
Message-ID: <CAOf5uw=-cy2QoDxjecxYTYsrQRD=LtN0N7DcYJHZ6HSbexzPRw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
From: Michael Trimarchi <michael@amarulasolutions.com>
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Nov 24, 2013 at 8:01 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Sunday 24 November 2013 18:18:03 Michael Trimarchi wrote:
>> Hi
>>
>> On Tue, Nov 19, 2013 at 11:18 AM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > This patch removing set_mode_hook function from board data
>> > and replacing it with new string variable of notifier power
>> > supply device. After this change it is possible to add DT
>> > support because driver does not need specific board
>> > function anymore. Only static data and name of power supply
>> > device is required.
>> >
>> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> > ---
>> >
>> >  drivers/power/bq2415x_charger.c       |   77
>> >  +++++++++++++++++++++++++--------
>> >  include/linux/power/bq2415x_charger.h |   48
>> >  +++----------------- 2 files changed, 65 insertions(+), 60
>> >  deletions(-)
>> >
> ...
>> >
>> > -       struct bq2415x_device *bq = data;
>> > +       struct bq2415x_device *bq =
>> > +               container_of(nb, struct bq2415x_device, nb);
>> > +       struct power_supply *psy = v;
>> > +       enum bq2415x_mode mode;
>> > +       union power_supply_propval prop;
>> > +       int ret;
>> > +       int mA;
>> >
>> > -       if (!bq)
>> > -               return;
>> > +       if (val != PSY_EVENT_PROP_CHANGED)
>> > +               return NOTIFY_OK;
>> > +
>> > +       if (strcmp(psy->name, bq->init_data.notify_device)
>> > != 0) +               return NOTIFY_OK;
>> > +
>> > +       dev_dbg(bq->dev, "notifier call was called\n");
>> > +
>> > +       ret = psy->get_property(psy,
>> > POWER_SUPPLY_PROP_CURRENT_MAX, &prop); +       if (ret !=
>> > 0)
>> > +               return NOTIFY_OK;
>>
>> So you can read this value without any type of synchronization
>> with the power_supply_core
>> and sysfs implementation?
>>
>>
>> Michael
>>
>
> I do not see reason why I cannot use it. When isp1704 driver send
> PSY_EVENT_PROP_CHANGED then property
> POWER_SUPPLY_PROP_CURRENT_MAX is already updated and can be read
> by get_property function.
>

https://lists.ubuntu.com/archives/kernel-team/2013-January/025206.html

I found and equivalent scenario that I was trying to said

Michael


> --
> Pali Rohár
> pali.rohar@gmail.com
