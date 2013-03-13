Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453Ab3CMXTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:19:34 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63323 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934428Ab3CMXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:19:31 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E487A0@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F79273676@DQHE02.ent.ti.com>
 <CAK5ve-KT3NEv=MYv2ZQ9YQ8L-TS9KFaL0VNXzO7KoG9gvSRGcg@mail.gmail.com> <A874F61F95741C4A9BA573A70FE3998F82E487A0@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 13 Mar 2013 16:19:09 -0700
Message-ID: <CAK5ve-+XCqrp8gkh4FE0Up0y+jDU7knowG1kXjpaf1+zuAhYhg@mail.gmail.com>
Subject: Re: [PATCH 2/3] leds: add LED Trigger for camera function
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:16 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>> > +#if defined(CONFIG_LEDS_TRIGGER_CAMERA) ||
>> defined(CONFIG_LEDS_TRIGGER_CAMERA_MODULE)
>> > +extern void ledtrig_flash_ctrl(bool on);
>> > +extern void ledtrig_torch_ctrl(bool on);
>> > +#else
>> > +#define ledtrig_flash_ctrl(x) do {} while(0)
>> > +#define ledtrig_torch_ctrl(x) do {} while(0)
>>
>> It's better don't use #define macros but use real empty functions like
>> this:
>> static inline void ledtrig_flash_ctrl(bool on)
>> {
>>         return;
>> }
>
> I agree, but other trigger functions are declared as do-while definition.
> So I would let them unify if it's not critical.
> I'd like to have your opinion, which is better.
>
> Thanks,
> Milo

I did same thing before, Andrew Morton corrected me like this. Please
feel free to submit patch to move other macros to empty functions.

Thanks,
-Bryan
