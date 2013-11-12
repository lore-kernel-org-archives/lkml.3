Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3KLBHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:07:23 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:45965 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3KLBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:07:17 -0500
Message-ID: <52817F42.2080706@gmail.com>
Date: Tue, 12 Nov 2013 05:07:14 +0400
From: Evgeny Boger <eugenyboger@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Fries <david@fries.net>
Subject: Re: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
References: <1384180614-9025-1-git-send-email-boger@contactless.ru> <10261384211376@web11j.yandex.ru> <5281691F.4060604@gmail.com> <37621384218204@web11j.yandex.ru>
In-Reply-To: <37621384218204@web11j.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+David Fries <david@fries.net>

Hi David,

Would you please comment on this?


11/12/2013 05:03 AM, Evgeniy Polyakov:
> Hi
>
> 12.11.2013, 03:32, "Evgeny Boger" <eugenyboger@gmail.com>:
>>> Why did you drop this check? It has nothing with w1-gpio driver
>> This check prevents master from implementing "set_pullup"  provided it does support only "write_bit" method.
>> The comment above states that
>>>   w1_io.c would need to support calling set_pullup before - * the last write_bit operation of a w1_write_8 which it currently - * doesn't.
>> which is kind of strange, since it describes what w1_io.c actually does support.
>>
>> w1_write_8 (w1_io.c:154, https://github.com/torvalds/linux/blob/master/drivers/w1/w1_io.c#L154):
>>>                  for (i = 0; i < 8; ++i) {
>>>                          if (i == 7)
>>>                                  w1_pre_write(dev);
>>>                          w1_touch_bit(dev, (byte >> i) & 0x1);
>>>                  }
>> It seems like w1_write_8() calls w1_pre_write(), which in turn calls set_pullup() just before the last write_bit().
>>
>> I'm not sure why this check was there in the first place.
> Please add author of those lines to clarify things.
> This doesn't look obvious to me

