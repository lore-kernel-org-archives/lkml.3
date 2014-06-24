Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaFXQBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:01:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58209 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaFXQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:01:31 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A9A0CB.1020607@roeck-us.net>
Date: Tue, 24 Jun 2014 09:01:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wim Van Sebroeck <wim@iguana.be>
CC: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com> <20140507213318.GA2105@roeck-us.net> <20140515091123.GQ29258@lukather> <20140519150422.GA27329@lukather> <20140522203444.GE27329@lukather> <20140522211207.GA28704@roeck-us.net> <20140623103142.GB19730@lukather> <20140623211323.GA28120@spo001.leaseweb.com> <20140624144954.GP19730@lukather>
In-Reply-To: <20140624144954.GP19730@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 07:49 AM, Maxime Ripard wrote:
> On Mon, Jun 23, 2014 at 11:13:24PM +0200, Wim Van Sebroeck wrote:
>> Hi Maxime,
>>
>>>>> Guenter, since you seem to be the only responsive, may I suggest that
>>>>> you start merging patches and do a pull request to either Wim or Linus
>>>>> directly during the merge window?
>>>>>
>>>> I had prepared a pull request for Wim last weekend or so, but then there
>>>> were more patches piling in and I got distracted, so I didn't have time
>>>> to actually send it. I'll try again this weekend ... the kids should be
>>>> busy learning for their finals, and I'll have Friday and Monday off
>>>> from work, so I should be able to find the time.
>>>>
>>>> As for sending patches to Linus directly, well, Wim is the watchdog maintainer.
>>>> I manage to upset enough people, and would not want to add Wim to the list.
>>>>
>>>> The patches _are_ in my watchdog-next branch and get some coverage from
>>>> both my auto-builders and from Fenguang's build robots, so while they are
>>>> not in linux-next, they are not completely in the dark either.
>>>
>>> So, this patch finally didn't make it into 3.16. Great. Now, we can't
>>> even reboot the boards.
>>
>> 1) For me the discussion was not ended and needs further
>> thinking. (And I just read some good ideas about it).
>
> It would have been great for you to mention it then.
>
>> 2) You never mentioned you needed this in for 3.16 and that things
>> would break because of it.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257690.html
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259109.html
>
> I thought it was pretty clear.
>
>>
>> So based on these 2 points why would I have to have put this in allready?
>>
>>> Given how it's just impossible to get something merged reliably
>>> through the watchdog tree, I guess I should just start merging the
>>> patches through mine?
>>
>> I agree that I have the problem of having only 24 hours in a day and
>> that I lack time to communicate and that I am not good at
>> communicating either, but I checked all sunxi related e-mails and
>> you never mentioned the constraint to have it in for 3.16...  But I
>> do understand your frustration.
>
> I totally understand the lack of time. A good way to ease your burden
> and solve this situation is usually to take a co-maintainer. And given
> that Guenter already reviews patches, maintains some branch, and is
> developping some part of the framework, he seems up to the task.
>

Let's focus on the problem at hand. I prepared a set of patches to add a
kernel restart notifier, quite similar to the existing reboot notifier.
Only question is where it should reside. So far it is in parallel
to the reboot notifier, ie in kernel/notifier.c and kernel/reboot.c.
Before I send it out for review, I'd like to get a notion if this is
the right approach, or if it is going to create heat from other sides.
Thoughts, anyone ?

On the plus side, this might have the potential of replacing arm_pm_restart,
which I think would be a good thing.

Thanks,
Guenter

