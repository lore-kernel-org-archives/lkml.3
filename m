Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaCLOdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:33:02 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60005 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaCLOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140310043328.GB27798@jenny-desktop>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
	<1394170174-21959-3-git-send-email-jenny.tc@intel.com>
	<20140307202520.GD27645@amd.pavel.ucw.cz>
	<20140310043328.GB27798@jenny-desktop>
Date: Wed, 12 Mar 2014 15:32:59 +0100
Message-ID: <CACRpkdaBv2-Grq3VPD8AqDS-aqaY9wtkaRqfkJCrEia1hTm0SA@mail.gmail.com>
Subject: Re: [PATCHv8 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jenny Tc <jenny.tc@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>,
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

On Mon, Mar 10, 2014 at 5:33 AM, Jenny Tc <jenny.tc@intel.com> wrote:
> On Fri, Mar 07, 2014 at 09:25:20PM +0100, Pavel Machek wrote:

>> > +   /* sort based on priority. 0 has the highest priority  */
>> > +   for (i = 0; i < cnt; ++i)
>> > +           for (j = 0; j < cnt; ++j)
>> > +                   if (psy_prioirty(psy_lst[j]) > psy_prioirty(psy_lst[i]))
>> > +                           swap(psy_lst[j], psy_lst[i]);
>> > +
>>
>> WTF? Bubble sort in kernel?
>
> Yes, it's bubble sort. Since the number of power supply objects in real systems
> (max 4) are limited, I feel the complexity would be as same as any other
> sorting algorithms. Any suggestions?

You already have a kernel quicksort implementation in lib/sort.c.

Please restructure the code to make use of this as it is already
compiled into every kernel.

Yours,
Linus Walleij
