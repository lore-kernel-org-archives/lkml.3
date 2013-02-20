Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab3BTIxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:53:52 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46957 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3BTIxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:53:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130220081311.GB3368@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
	<1360933026-30325-7-git-send-email-lee.jones@linaro.org>
	<201302192204.45153.arnd@arndb.de>
	<20130220081311.GB3368@gmail.com>
Date: Wed, 20 Feb 2013 09:53:50 +0100
Message-ID: <CAEKpxBk=bgTx18A2J6mVT5RBBq3ZJAqswz-6NvNpTRP=u9pgwQ@mail.gmail.com>
Subject: Re: [PATCH 06/35] mfd: ab8500-core: Sysfs chip id modification
From: Marcus Cooper <codekipper@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2013 09:13, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 19 Feb 2013, Arnd Bergmann wrote:
>
>> On Friday 15 February 2013, Lee Jones wrote:
>> >         struct ab8500 *ab8500;
>> > +       int chip_id = -EINVAL;
>> >
>> >         ab8500 = dev_get_drvdata(dev);
>> > -       return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
>> > +       if(ab8500) {
>> > +               chip_id = ab8500->chip_id;
>> > +               if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
>> > +                       chip_id = (ab8500->version << 8) | chip_id;
>> > +       }
>> > +       return sprintf(buf, "%#x\n", chip_id);
>> >  }
>>
>> What's the use of printing "ffffffea" for unknown versions here?
>
> You mean instead of -EINVAL? No idea, Marcus?
>
Looks like I'm guilty of just making the minimal changes. Arnd is
right though, getting ffffffea(-EINVAL) back is pretty useless.
I'll have to check user land to see what is using this. Maybe not
printing and returning 0 should be the correct behaviour
when an unknown version is found.
