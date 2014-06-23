Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaFWObN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:31:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61879 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaFWObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:31:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A83A20.6090800@roeck-us.net>
Date: Mon, 23 Jun 2014 07:30:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be
CC: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com> <20140507213318.GA2105@roeck-us.net> <20140515091123.GQ29258@lukather> <20140519150422.GA27329@lukather> <20140522203444.GE27329@lukather> <20140522211207.GA28704@roeck-us.net> <20140623103142.GB19730@lukather>
In-Reply-To: <20140623103142.GB19730@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 03:31 AM, Maxime Ripard wrote:
> On Thu, May 22, 2014 at 02:12:07PM -0700, Guenter Roeck wrote:
>> On Thu, May 22, 2014 at 10:34:44PM +0200, Maxime Ripard wrote:
>>> On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
>>>> On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
>>>>> On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
>>>>>> On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
>>>>>>> Most of the watchdog code is duplicated between the machine restart code and
>>>>>>> the watchdog driver. Add the restart hook to the watchdog driver, to be able to
>>>>>>> remove it from the machine code eventually.
>>>>>>>
>>>>>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>>>>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>>>>>
>>>>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>>>>
>>>>> Wim, do you have any comment on this one?
>>>>
>>>> Ping?
>>>>
>>>> It would be really great to see this in 3.16, and we get quite close
>>>> to the end of ARM's merge window.
>>>
>>> Ping?
>>>
>>> Guenter, since you seem to be the only responsive, may I suggest that
>>> you start merging patches and do a pull request to either Wim or Linus
>>> directly during the merge window?
>>>
>> I had prepared a pull request for Wim last weekend or so, but then there
>> were more patches piling in and I got distracted, so I didn't have time
>> to actually send it. I'll try again this weekend ... the kids should be
>> busy learning for their finals, and I'll have Friday and Monday off
>> from work, so I should be able to find the time.
>>
>> As for sending patches to Linus directly, well, Wim is the watchdog maintainer.
>> I manage to upset enough people, and would not want to add Wim to the list.
>>
>> The patches _are_ in my watchdog-next branch and get some coverage from
>> both my auto-builders and from Fenguang's build robots, so while they are
>> not in linux-next, they are not completely in the dark either.
>
> So, this patch finally didn't make it into 3.16. Great. Now, we can't
> even reboot the boards.
>
> Given how it's just impossible to get something merged reliably
> through the watchdog tree, I guess I should just start merging the
> patches through mine?
>

You can not really blame Wim here.

In this case, I suspect the major reason for not accepting the patch
is that I tried to provide a clean method / API for "reset through watchdog
subsystem", which went nowhere, in my understanding because someone objected
that it would be the wrong thing to do [1] and it didn't get approval /
acceptance from the arm maintainers. If it is wrong to reset the board
from the watchdog subsystem in a clean way, it is for sure even more wrong
to do it as you proposed in your patch.

My conclusion therefore is that all board reset code should move back out
of the watchdog subsystem, and that we should not accept such code in the
future. This is not my personal preference, but I do believe that we should
do it in a clean way or not at all.

Guenter

---
[1] https://lkml.org/lkml/2014/5/15/838
