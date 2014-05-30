Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaE3M6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:58:06 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:55353 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaE3M6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:58:04 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: migueloliv@gmail.com
In-Reply-To: <20140530123533.GB10549@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
	<20140530113418.GA9670@amd.pavel.ucw.cz>
	<CAMGgR5swX-cp4navRBu8CxYnL5fRSxkBVRcu-xKXkr0oyBXP+A@mail.gmail.com>
	<20140530123533.GB10549@amd.pavel.ucw.cz>
Date: Fri, 30 May 2014 13:58:02 +0100
X-Google-Sender-Auth: m6a0ry5nVKTjMVd626Ztu1LQQUk
Message-ID: <CAMGgR5ui-4+7-VKSpJ5_NukbkuxK1sRWg0RsS=Ai+Vs2xn119A@mail.gmail.com>
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
From: Miguel Oliveira <cmroliv@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@linuxfoundation.org,
        =?UTF-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        pali.rohar@gmail.com, peter.p.waskiewicz.jr@intel.com,
        =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not on my prespective. Its says "~20 ms actual sleep for any value
given in the 1~20ms range", so from my point of view it will sleep for
20ms, so I will save between 5 to 10ms. But maybe I'm seeing it the
wrong way.


Regards

2014-05-30 13:35 GMT+01:00 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> So the /Documentation/timers/timers-howto.txt stats:
>>
>> SLEEPING FOR ~USECS OR SMALL MSECS ( 10us - 20ms):
>> * Use usleep_range
>>
>> - Why not msleep for (1ms - 20ms)?
>> Explained originally here:
>> http://lkml.org/lkml/2007/8/3/250
>> msleep(1~20) may not do what the caller intends, and
>> will often sleep longer (~20 ms actual sleep for any
>> value given in the 1~20ms range). In many cases this
>> is not the desired behavior.
> ...
>> Should the documentation should be ignored?
>
> Caller wants to sleep for 10ms; docs said it may sleep for 10-20msec;
> that sounds reasonable. You replaced it with busy-loop for 10-15msec.
>
> That does not sound like improvement.
>
> Thanks,
>                                                                 Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
