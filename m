Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaCLOki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:40:38 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56381 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaCLOkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <1394170174-21959-3-git-send-email-jenny.tc@intel.com>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
	<1394170174-21959-3-git-send-email-jenny.tc@intel.com>
Date: Wed, 12 Mar 2014 15:40:35 +0100
Message-ID: <CACRpkdZu6HC3S=p4f1rfETGZroXicMuCU0e9Y8=CtQiOq7Q+UQ@mail.gmail.com>
Subject: Re: [PATCHv8 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 6:29 AM, Jenny TC <jenny.tc@intel.com> wrote:

> +enum psy_charger_cable_type {
> +       PSY_CHARGER_CABLE_TYPE_NONE = 0,
> +       PSY_CHARGER_CABLE_TYPE_USB_SDP = 1 << 0,
> +       PSY_CHARGER_CABLE_TYPE_USB_DCP = 1 << 1,
> +       PSY_CHARGER_CABLE_TYPE_USB_CDP = 1 << 2,
> +       PSY_CHARGER_CABLE_TYPE_USB_ACA = 1 << 3,
> +       PSY_CHARGER_CABLE_TYPE_AC = 1 << 4,
> +       PSY_CHARGER_CABLE_TYPE_ACA_DOCK = 1 << 5,
> +       PSY_CHARGER_CABLE_TYPE_ACA_A = 1 << 6,
> +       PSY_CHARGER_CABLE_TYPE_ACA_B = 1 << 7,
> +       PSY_CHARGER_CABLE_TYPE_ACA_C = 1 << 8,
> +       PSY_CHARGER_CABLE_TYPE_SE1 = 1 << 9,
> +       PSY_CHARGER_CABLE_TYPE_MHL = 1 << 10,
> +       PSY_CHARGER_CABLE_TYPE_B_DEVICE = 1 << 11,
> +};

I still disagree with using an enum as bitfield.

Atleast
#include <linux/bitops.h>
and use BIT(0), BIT(1) etc to define the bits.

Yours,
Linus Walleij
