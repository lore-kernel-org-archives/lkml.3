Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3JFP6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:58:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:52908 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3JFP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:58:18 -0400
X-Spam-Score: -101.5
Message-ID: <52518850.6050303@asianux.com>
Date: Sun, 06 Oct 2013 23:57:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/irq/proc.c: set MAX_NAMELEN 11 instead of 10 which
 express the maximize size of "%d" or "%u".
References: <52502E14.5040507@asianux.com> <1380987671.2081.122.camel@joe-AO722> <52503441.2030009@asianux.com> <CAFLxGvy0+9tu5PF2kKrUyVRobixtLaSs_u_b9zwFj64YvQrxgw@mail.gmail.com> <52504373.8070606@asianux.com> <52504718.30303@asianux.com> <52505048.8000604@nod.at> <5250B0E3.3070500@asianux.com>
In-Reply-To: <5250B0E3.3070500@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 08:37 AM, Chen Gang wrote:
> On 10/06/2013 01:45 AM, Richard Weinberger wrote:
>> Am 05.10.2013 19:06, schrieb Chen Gang:
>>> On 10/06/2013 12:50 AM, Chen Gang wrote:
>>>> On 10/06/2013 12:08 AM, Richard Weinberger wrote:
>>>>> On Sat, Oct 5, 2013 at 5:46 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>> On 10/05/2013 11:41 PM, Joe Perches wrote:
>>>>>>> On Sat, 2013-10-05 at 23:19 +0800, Chen Gang wrote:
>>>>>>>> Theoretically, the maximize size of "%d" or "%u" is 11 (10 + '\0'), so
>>>>>>>> need set MAX_NAMELEN 11 instead of 10.
>>>>>>>
>>>>>>> %d can be negative.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Oh, really, it is incorrect. Al Viro succeeds once.  :-(
>>>>>>
>>>>>> And I should send patch v2 for it.
>>>>>
>>>>> irq is in both register_irq_proc() and unregister_irq_proc() an unsigned int.
>>>>> Therefore %d makes not really sense. Both should use %u.
>>>>> IMHO sprintf() should also get replaced by snprintf() but that's a
>>>>> matter of taste.
>>>>>
>>>
>>> Oh, commonly, snprintf() are used for the string which can be truncated,
>>> and can not be used for the string which contents must not be truncated.
>>>
>>> In our case, the name string must be not truncated (or may not unique,
>>> theoretically), so we have to still use sprintf().
>>
>> Of course you would have to check the return value of snprintf() to detect
>> a truncation and abort...
>>
> 
> OK, thanks, that sounds reasonable to me, so I feel that's not a matter
> of taste.
> 

Hmm... does 'taste' means: "for string which can not be truncated, if
maximized length is obvious (e.g. our case 11 for "%u"), sprintf() is
more clearer than snprintf() for both readers and writers"?


BTW: when MAX_NAMELEN is defined as 128, is it suitable to check the
return value of snprintf() in register_handler_proc(), and WARN_ON() if
it is not less than 128?


Thanks.

> In my opinion, when we know the maximized length, we need always use
> s(c)nprintf instead of sprintf, if the string can be truncated, use
> scnprintf, else use snprintf and also check the return value.
> 
> sprintf is 'dangrous', need try to use s(c)nprintf instead of. We can
> scan whole kernel, I guess quite a few of sprintf may be related with
> memory overflow 'theoretically' (welcome any members to give a check).
> 
> 
> Thanks.
> 
>> Thanks,
>> //richard
>>
>>
>>
> 


-- 
Chen Gang
