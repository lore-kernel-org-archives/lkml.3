Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3ENIuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:50:54 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:44896 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3ENIuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130514084756.GE3297@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-9-git-send-email-lee.jones@linaro.org>
	<CACRpkdZTU1gv3onjFF4eqxv-o1BQwd48u4gQ9NWqryWoMiKTDQ@mail.gmail.com>
	<20130514084756.GE3297@gmail.com>
Date: Tue, 14 May 2013 10:50:51 +0200
Message-ID: <CACRpkdbhHnrN3MGufubyYLNXdcCgZ2OpQ4a2CG6bwPJk88DZRg@mail.gmail.com>
Subject: Re: [PATCH 8/9] pinctrl: abx500: Rejiggle platform data and DT initialisation
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 10:47 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 14 May 2013, Linus Walleij wrote:
>
>> On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > A pointer to GPIO platform data is always passed to the driver now, so
>> > there's little point in checking for 'pdata' and executing the DT case if
>> > it's not there. The difference between booting with DT and !DT is when
>> > booting with DT, plat_id is not populated. Thus, in the DT case we have
>> > to use a DT match table in order to find out which platform we're
>> > executing on. So, we're changing the semantics here to only use the
>> > match table if no plat_id is supplied though platform data.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Is this really included in the [0/9] fire alarm wrapper statement
>> "Important ux500 fixups due for the v3.10 -rc:s"?
>>
>> It seems more like a random refactoring to me.
>>
>> The commit message fails to specify which regression this
>> is fixing, like if it's causing an oops or so.
>>
>> So I've tentatively applied it to the pinctrl devel branch for
>> v3.11 unless something comes up...
>
> Perhaps the commit message is a bit weak, but yes, it _needs_ to go
> into v3.10, or this driver will be _broken_ when we boot with DT.
>
> Please apply this to your -fixes branch.

Quting myself from above:
  "The commit message fails to specify which regression this
  is fixing, like if it's causing an oops or so."

I'm happy to apply it but what do I write in the commit message?

Yours,
Linus Walleij
