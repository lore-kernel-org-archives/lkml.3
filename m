Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3B1EiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:38:14 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:59977 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1EiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:38:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130226110740.GA3962@katana>
References: <88.A5.02716.F6CB6215@epcpsbge3.samsung.com>
	<alpine.LNX.2.00.1302261101250.2128@pobox.suse.cz>
	<20130226110740.GA3962@katana>
Date: Thu, 28 Feb 2013 10:08:07 +0530
Message-ID: <CAK7N6vrSMBgO9=2vfB3PCG0e0WDhkTwQ0wLpJLhicu4U61ym5g@mail.gmail.com>
Subject: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon in 3.8
From: anish singh <anish198519851985@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?B?7Iah7J2A67SJ?= <eunb.song@samsung.com>,
        linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 4:37 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Tue, Feb 26, 2013 at 11:02:17AM +0100, Jiri Kosina wrote:
>> On Fri, 22 Feb 2013, 송은봉 wrote:
>>
>> >
>> >
>> >
>> > I've been debugging the abnormal operation of i2c on octeon.
>> > If a process is terminated by signal in the middle of i2c operation,
>> > next i2c read operation which is done by another process was failed.
>> > So i changed to ignore signal in the middle of i2c operation.
>> > After that the problem was not reproduced.
>>
>> This is not really material directly for trivial.git. Adding maintainers
>> to CC.
>
> Yes, this should not go via trivial. Please resend to i2c list. Patch
> looks okay from a glimpse (and fixes an issue we have seen before and
> fixed the same way).
Just curios to know why reinitializing the i2c controller is a bad idea?
This fix looks perfect but if we know that there is only one i2c device
currently being controlled by controller.Can we(i know it is expensive
compare to the fix provided) not re-initialize the i2c-controller?

Thanks,
>
> Thanks,
>
>    Wolfram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
