Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbbAVUxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:53:54 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55489 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbbAVUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <20150122192649.GC14880@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
	<20150122144522.GF3413@katana>
	<CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
	<20150122150717.GJ3413@katana>
	<87wq4e7jqy.fsf@dell.be.48ers.dk>
	<20150122185711.GA14880@katana>
	<CAMo8BfJdmB-=i4bJypHzGvegxgBPafpiT_hyQXLhvzBUmE+u_g@mail.gmail.com>
	<20150122192649.GC14880@katana>
Date: Thu, 22 Jan 2015 23:53:51 +0300
Message-ID: <CAMo8BfJqS1O=ZiVs89wsuNuQ_Qt=2BJtcens=09POucM_OjXrQ@mail.gmail.com>
Subject: Re: [PATCH] i2c-ocores: add common clock support
From: Max Filippov <jcmvbkbc@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Korsgaard <peter@korsgaard.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:26 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Jan 22, 2015 at 10:15:40PM +0300, Max Filippov wrote:
>> On Thu, Jan 22, 2015 at 9:57 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> > My suggestion is:
>> >
>> > 1) if there is a clk node:
>> >         - we get the clock rate via clock framework
>> >         - "clock-frequency" is describing the bus speed as usual (Note
>> >           that parsing here can be as simple as checking for 100kHz only.
>> >           Although a seperate patch could probably easily add support for
>> >           other bus speeds to)
>> >
>> > 2?) a new binding is present to specify the IP clock speed:
>> >         - is this needed? is somebody using the driver without CCF?
>> >         - if so, the new binding is parsed and evaluated
>> >         - I couldn't find an existing binding to specify a clock speed.
>> >           Please have a look, too. Otherwise we need to introduce sth
>> >           like "opencores,ip-clock-khz" probably.
>> >         - "clock-frequency" is describing the bus speed as usual
>> >
>> > 3) only "clock-frequency" is present:
>> >         - we keep the current behaviour to be backwards compatible.
>> >         - driver should emit a warning to convert to new style
>> >         - must be marked deprecated everywhere
>> >
>> > The documentation should be updated accordingly.
>> >
>> > Thoughts?
>>
>> I can update my patch to do (1) and (3), leaving (2) to whoever may
>> need that.
>
> Please implement (2) as well. Otherwise we would have documented
> ambiguity of "clock-frequency" which is bad. It shouldn't be much code.

There will be ambiguity if we want to maintain backwards compatibility,
so we're documenting it anyway. And since we're going to maintain it,
those who don't use CCF will still have option (3). Is there a point in
introducing (2) which currently does not exist and thus has no users?

-- 
Thanks.
-- Max
