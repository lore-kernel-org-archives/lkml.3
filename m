Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaCGDGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:06:53 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55265 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaCGDE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:04:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140228100114.GA13189@amd.pavel.ucw.cz>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
	<1392875640-29230-3-git-send-email-jenny.tc@intel.com>
	<CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
	<20140228100114.GA13189@amd.pavel.ucw.cz>
Date: Fri, 7 Mar 2014 11:04:59 +0800
Message-ID: <CACRpkdaZ2moqGWx2BpfEeKoW6doXg67TkJKY+mbg4hrFHDr16Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jenny TC <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
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

On Fri, Feb 28, 2014 at 6:01 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2014-02-27 21:08:01, Linus Walleij wrote:
>> On Thu, Feb 20, 2014 at 6:53 AM, Jenny TC <jenny.tc@intel.com> wrote:
>>
>> > +++ b/include/linux/power/power_supply_charger.h
>>
>> > +#define MAX_CUR_VOLT_SAMPLES 3
>> > +#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)
>>
>> Why are things defined in Jiffies like this insead of seconds, milliseconds
>> etc? This will vary with the current operating frequency of the system,
>> why should physical measurements do that?
>
> It is actually ok. The define is relative to jiffies, and that's what
> interface expects.

So consider the option that the interface is wrong.

Stating something like a sample period in system-specific jiffies
instead of period time T is just weird. What control systems
guy would understand this?

Yours,
Linus Walleij
