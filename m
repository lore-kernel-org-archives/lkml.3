Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaK3QEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:04:24 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:33236 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaK3QEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:04:22 -0500
Message-ID: <547B4003.1040301@roeck-us.net>
Date: Sun, 30 Nov 2014 08:04:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411292007.36975@pali> <547A71F5.4030306@roeck-us.net> <201411301111.35988@pali>
In-Reply-To: <201411301111.35988@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.547B4006.007C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 6
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

On 11/30/2014 02:11 AM, Pali Rohár wrote:
> On Sunday 30 November 2014 02:25:09 Guenter Roeck wrote:
>> On 11/29/2014 11:07 AM, Pali Rohár wrote:
>> [ ... ]
>>
>>> Original Dell DOS executable ignores all temperature sensors
>>> if type SMM function fails (if I decoded and understand
>>> that DOS assembler code correctly). So maybe we should do
>>> same...
>>
>> Pali,
>>
>> Makes me wonder - does the assembler code tell you what to do
>> if the reported temperature is invalid, and does it
>> distinguish between error codes ?
>
> I do not see anything like that. But there are lot of indirect
> calls (offset to pointer to function is stored in some global at
> init zero data), so it is hard to understand what that DOS binary
> is doing. I'm happy that I decoded loop which trying to call that
> type function and if it does not fail then it call read
> temperature function. And in that section I do not see any error
> handling of invalid values (but it could be somewhere else).
>
> Anyway DOS binary is quite old (7 years maybe?). It is not even
> available for my last E6440 model. Now all new Dell laptops have
> EFI system and ePSA application (new version of diagnostic tool
> which reports info about fan, temperature, ...). That tool looks
> like is burned directly into machine (I can start it with empty
> HDD from Setup screen) or into BIOS image.
>
> And what is interesting about this ePSA:
>
> * it show more temperature sensors (battery temperature)
> * it show correct RPM of fan and *can* control fan speed
>
> I think that DOS binary has no idea about Optimus or PowerExpress
> cards so for that error handling we need to understand what is
> doing new EFI ePSA application...
>
> And because function for turning card on/off is controlled via
> ACPI I bet that DOS or EFI application does not touch it, so
> assume that card is always on and does not need any error
> handling.
>
> Another info about DOS binary: After SMM code for reading fan RPM
> is finished, then function divide returned RPM value by some
> number stored in local data. So now I think that magic fan
> multiplier is not constant, but runtime value. I will try to look
> at it, if we can fix this problem in linux i8k.c.
>
It might be system specific. After all, it is known that old laptops
need a different multiplier.

>> So far we have
>> 	0x99 - presumably a spurious error
>> 	0xc1 - GPU temperature sensor, GPU turned off
>>
>> It would be nice if we could find a better solution for error
>> handling.
>>
>
> Yes, but now we can only guess... My idea is that Dell SMM
> handler does not check GPU presence at runtime and just try to
> read info from PCI bus. And because turned off card is not there
> just random (or non random) garbage is returned...
>
Well, it was worth a try. It might be that, or SMM does handle it,
but that the DOS application is too old to understand it.

Thanks,
Guenter

