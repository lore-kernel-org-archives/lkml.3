Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaAVJym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:54:42 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36429 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaAVJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:54:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
	<CAAVeFuLP4MkfXGG1FMauvUw_J63zRXdhGwxqYy5W98L1wCQNbw@mail.gmail.com>
	<CACRpkdYiy+sya6NqRfAmsrFOXvaa3qX=qjRuTDW1vZVSaG1+Gg@mail.gmail.com>
	<201401211335.16885.arnd@arndb.de>
	<CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
Date: Wed, 22 Jan 2014 10:54:34 +0100
Message-ID: <CACRpkdbCQ3UHUJ5TLYqD9svOiuFBK9ManepiJ745PiU9fHjpFA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 3:53 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Jan 21, 2014 at 9:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 21 January 2014, Linus Walleij wrote:

>>> As discussed earlier in this thread I'm not sure the con_id is
>>> suitable for labelling GPIOs. It'd be better to have a proper name
>>> specified in DT/ACPI instead.
>>
>> +1
>
> I wonder why you guys prefer to have the name defined in the GPIO
> mapping. Having the driver decide the label makes it easier to look up
> which GPIO does what in debugfs, whereas nothing prevents people to
> name GPIOs whatever inadequate name they want in the device DT node.
> What am I overlooking here?

The proper name of a GPIO does not come from the driver but from the
usecase, i.e. often the name of the rail on the board where it is used.

Remember GPIO are per definition general purpose, they cannot get
any clever names from the driver. They would just be named
"chip-foo-gpio0" thru "chip-foo-gpioN" if the driver was to name them.

Using the rail name on the board is way more useful. A GPIO line
named "HAL_SENSOR" or "MMC_CD" is actually telling us what
that line is used for.

But such names can only come from a DT or ACPI table that has
knowledge of how the GPIO is used on a certain system/board and
not just from the driver.

Yours,
Linus Walleij
