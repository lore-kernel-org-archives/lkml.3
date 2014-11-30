Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaK3AHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 19:07:20 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36557 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaK3AHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 19:07:18 -0500
Message-ID: <547A5FB3.6030502@roeck-us.net>
Date: Sat, 29 Nov 2014 16:07:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <2162660.rjBG3mszUn@xps13> <547A1754.20903@roeck-us.net> <201411292007.36975@pali>
In-Reply-To: <201411292007.36975@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020208.547A5FB6.002E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
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

On 11/29/2014 11:07 AM, Pali Rohár wrote:
> On Saturday 29 November 2014 19:58:28 Guenter Roeck wrote:
>> On 11/29/2014 10:27 AM, Gabriele Mazzotta wrote:
>>> On Saturday 29 November 2014 18:18:18 Pali Rohár wrote:
>>>> On Saturday 29 November 2014 18:07:19 Gabriele Mazzotta
> wrote:
>>>>> On Saturday 29 November 2014 17:09:35 Pali Rohár wrote:
>>>>>> On Saturday 29 November 2014 17:04:07 Pali Rohár wrote:
>>>>>>> This patch adds labels for temperature sensors if SMM
>>>>>>> function with EAX register 0x11a3 reports it. These
>>>>>>> informations was taken from DOS binary NBSVC.MDM.
>>>>>>>
>>>>>>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>>>>>>> ---
>>>>>>>
>>>>>>>    drivers/char/i8k.c |  110
>>>>>>>
>>>>>>> +++++++++++++++++++++++++++++++++++++++++----------- 1
>>>>>>> file changed, 88 insertions(+), 22 deletions(-)
>>>>>>
>>>>>> I tested patch on Latitude E6440 and i8k CPU & GPU temps
>>>>>> match intel coretemp & amd radeion temps.
>>>>>>
>>>>>> But I would like if somebody with other Dell laptop can
>>>>>> test if temperature labels are correct...
>>>>>
>>>>> I tested it on my XPS13 9333, here what sensors outputs:
>>>>>
>>>>> acpitz-virtual-0
>>>>> Adapter: Virtual device
>>>>> temp1:        +27.8°C  (crit = +105.0°C)
>>>>> temp2:        +29.8°C  (crit = +105.0°C)
>>>>>
>>>>> coretemp-isa-0000
>>>>> Adapter: ISA adapter
>>>>> Physical id 0:  +62.0°C  (high = +100.0°C, crit =
>>>>> +100.0°C) Core 0:         +62.0°C  (high = +100.0°C, crit
>>>>> = +100.0°C) Core 1:         +61.0°C  (high = +100.0°C,
>>>>> crit = +100.0°C)
>>>>>
>>>>> i8k-virtual-0
>>>>> Adapter: Virtual device
>>>>> fan2:           0 RPM
>>>>> CPU:          +62.0°C
>>>>> Ambient:      +49.0°C
>>>>> SODIMM:       +46.0°C
>>>>> temp4:            N/A
>>>>>
>>>>> CPU seems to be correct, but I can't say anything on
>>>>> Ambient and SODIMM. temp4 is constantly equal to SODIMM
>>>>> without this patch, so I'd say N/A is correct.
>>>>>
>>>>>
>>>>> Gabriele
>>>>
>>>> It is unknown for me how to directly read Ambient and
>>>> SODIMM temperatures (without Dell SMM functions). So we
>>>> can only trust Dell SMM that it reporting correct values
>>>> and type is really Ambient and SODIMM.
>>>>
>>>> And about temp4:
>>>>
>>>> Label is not set when SMM function fails. Original DOS
>>>> NBSVC.MDM just ignore all sensors for which SMM type
>>>> function fails.
>>>>
>>>> This patch should not disable any sensor, so if you
>>>> previously had some value (<= 128°C) and now not, then
>>>> there is some bug.
>>>>
>>>> Can you test this patch?
>>>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-mi
>>>> sc.git/comm
>>>> it/?h=char-misc-testing&id=723493ca59c8d81fed3e7f261165fee
>>>> 493a29ffa
>>>>
>>>> It is possible that same value is caused by incorrect use
>>>> of prev[] array which should be fixed by above patch.
>>>>
>>>> Can you test i8k with and without above patch?
>>>
>>> I did some more tests. What I think is happening is that
>>> temp4_label returns -22, so I sensors prints N/A without
>>> actually reading temp4_input.
>>>
>>> I'm doing some tests to understand what's going on with
>>> temp4_input. It reports the value of the last temp*_input I
>>> read. If I read it right after I loaded i8k, I get an error
>>> (-22).
>>>
>>> The same doesn't happen for temp3_label, which constantly
>>> returns -22.
>>>
>>> I already had
>>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-mi
>>> sc.git/commit/?h=char-misc-testing&id=723493ca59c8d81fed3e7f
>>> 261165fee493a29ffa applied. Without it, things seem not to
>>> change much. I either get an error (-22) or some incorrect
>>> values (for now always 1000) when I read temp4_input right
>>> after i8k was loaded. Once I read some other temp*_input, I
>>> always get the last value read.
>>
>> I am seeing exactly the same behavior on an XPS13.
>>
>> Guenter
>
> Original Dell DOS executable ignores all temperature sensors if
> type SMM function fails (if I decoded and understand that DOS
> assembler code correctly). So maybe we should do same...
>
> But because our i8k.c code ignores sensor only if it returns
> invalid temperature, there could be possible regression that on
> same machines type SMM function is not implemented or not
> working...
>
> What do you think?
>

Tested with XPS13, Studio 1555 (with GPU), and XPS M140.
Reading the type works with all of them. The Studio 1555
reports the GPU temperature in temp4. The M140 is quite old
(about 10 years), so I guess we can be reasonably sure that
all laptops currently in use support reporting the type.

Do you know what is returned for the type if the GPU is turned
off on a system with GPU ? I think that is the only open
question.

Thanks,
Guenter

