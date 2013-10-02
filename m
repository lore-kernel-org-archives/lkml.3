Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3JBECR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 00:02:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56465 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3JBECQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 00:02:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524B9ABF.6040000@roeck-us.net>
Date: Tue, 01 Oct 2013 21:02:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chris Murphy <bugzilla@colorremedies.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
References: <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131001105526.GA481@polaris.bitmath.org> <20131001151954.GB14887@roeck-us.net> <C10D98EE-28FE-4BFE-BDE5-1EAABF112AC2@colorremedies.com> <20131001162425.GD14887@roeck-us.net> <28FA6820-7FB5-4D33-ABC9-1F2088FA22A6@colorremedies.com> <20131002035156.GA566@roeck-us.net> <CAFC20BD-C5B7-4705-932E-930501159502@colorremedies.com>
In-Reply-To: <CAFC20BD-C5B7-4705-932E-930501159502@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 08:55 PM, Chris Murphy wrote:
>
> On Oct 1, 2013, at 9:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>
>> On Tue, Oct 01, 2013 at 07:09:26PM -0600, Chris Murphy wrote:
>>>
>>> On Oct 1, 2013, at 10:24 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>>> On Tue, Oct 01, 2013 at 09:33:13AM -0600, Chris Murphy wrote:
>>>>>
>>>>> On Oct 1, 2013, at 9:19 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>
>>>>>> On Tue, Oct 01, 2013 at 12:55:26PM +0200, Henrik Rydberg wrote:
>>>>>>>>> Warning message triggered with 3.12.0-0.rc3.git0.1.fc21.x86_64.
>>>>>>>>>
>>>>>>>>> [   10.886016] applesmc: key count changed from 261 to 1174405121
>>>>>>>>>
>>>>>>>>
>>>>>>>> Explains the crash, but the new key count is very wrong. 1174405121 = 0x46000001.
>>>>>>>> Which I guess explains the subsequent memory allocation error in the log.
>>>>>>>>
>>>>>>>> Henrik, any idea what might be going on ? Is it possible that the previous
>>>>>>>> command failure leaves some state machine in a bad state ?
>>>>>>>
>>>>>>> I seem to recall a report on another similar state problem on newer
>>>>>>> machines, so maybe, yes. Older machines seem fine, I have never
>>>>>>> encountered the problem myself. Here is a patch to test that
>>>>>>> theory. It has been tested to be pretty harmless on two different
>>>>>>> generations.
>>>>>>>
>>>>>>> I really really do not want to add an 'if (value is insane)' check ;-)
>>>>>>>
>>>>>> Chris,
>>>>>>
>>>>>> any chance you can load this patch on an affected machine so we can get
>>>>>> test feedback ? This one is too experimental to submit upstream without
>>>>>> knowing that it really fixes the problem.
>>>>>
>>>>> Yes. What kernel.org source version should I apply it against? I'd use the non-debug config file from an equivalent version Fedora kernel, unless asked otherwise. And also should I test it on other vintages? I have here MBP4,1(2008); MBP8,2(2011), and MBP10,2(2012).
>>>>>
>>>> Only requirement is that it also includes the previous patch, so it would be
>>>> optimal if you can apply it on top of the previous image.
>>>
>>> Patch added on top of 3.12.0-0.rc3.git0.1.fc20.x86_64 and built. But after ~dozen reboots, I'm not triggering the problem. The only items in dmesg with smc in it:
>>>
>>> [   13.799819] applesmc: key=261 fan=2 temp=14 index=14 acc=1 lux=2 kbd=1
>>> [   13.833402] input: applesmc as /devices/platform/applesmc.768/input/input10
>>>
>>
>> Hi Chris,
>>
>> That only means that you did not hit the problem. There may be some secondary
>> trigger (cold boot ? coffee on the cpu ?).
>>
>> One thing I have seen in all logs is the earlier "send_byte fail" message, so
>> I think that is a pre-requisite.
>
> I have no idea how to trigger it. I have tried cold and warm boots. Boots between linux and OS X to linux. *shrug* I'll keep trying as I'm doing other testing, maybe I'll stumble onto it.
>

I am sure you didn't pour coffee onto the CPU yet :)

Basic rule of testing: You'll only hit the problem again after you are convinced
that it was magically fixed by a completely unrelated change.

Cheers,
Guenter

