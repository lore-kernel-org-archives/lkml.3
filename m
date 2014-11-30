Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaK3RyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:54:25 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:42744 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaK3RyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:54:24 -0500
Message-ID: <547B59CD.90305@roeck-us.net>
Date: Sun, 30 Nov 2014 09:54:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411301053.40222@pali> <547B3F12.9030705@roeck-us.net> <201411301844.44562@pali>
In-Reply-To: <201411301844.44562@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020202.547B59CF.011F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 1
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 09:44 AM, Pali Rohár wrote:
> On Sunday 30 November 2014 17:00:18 Guenter Roeck wrote:
>> On 11/30/2014 01:53 AM, Pali Rohár wrote:
>> [ ... ]
>>
>>>>> Original Dell DOS executable ignores all temperature
>>>>> sensors if type SMM function fails (if I decoded and
>>>>> understand that DOS assembler code correctly). So maybe
>>>>> we should do same...
>>>>>
>>>>> But because our i8k.c code ignores sensor only if it
>>>>> returns invalid temperature, there could be possible
>>>>> regression that on same machines type SMM function is not
>>>>> implemented or not working...
>>>>>
>>>>> What do you think?
>>>>
>>>> Tested with XPS13, Studio 1555 (with GPU), and XPS M140.
>>>> Reading the type works with all of them. The Studio 1555
>>>> reports the GPU temperature in temp4. The M140 is quite old
>>>> (about 10 years), so I guess we can be reasonably sure that
>>>> all laptops currently in use support reporting the type.
>>>
>>> Good. Then I will split this patch into two parts. One which
>>> adds labels and one which change init code to register only
>>> those sensors which have valid type.
>>
>> Ok.
>>
>>>> Do you know what is returned for the type if the GPU is
>>>> turned off on a system with GPU ? I think that is the only
>>>> open question.
>>>
>>> Yes, on my E6440 in both cases when GPU is turned off and on
>>> is returned same type (GPU). So this does not help us.
>>
>> Unless I misunderstand you, it does help us; it simplifies
>> sensor detection since we don't have to handle the special
>> case that the GPU is turned off anymore.
>>
>> Thanks,
>> Guenter
>
> Yes, sensor type is returned always correctly, so this is good.
>
> I mean that it cannot be used for detecting if GPU is turned on
> or off.
>

Yes, but that is a good thing, because it helps us figuring out
if the GPU sensor should be enabled or not during probe,
so we no longer need to try reading the temperature, and we
no longer have to handle the case of "GPU supported, but turned
off" during probe.

When reading the temperature, returning -ENODATA if the GPU
is turned off is the best we can do.

Thanks,
Guenter

