Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaIUSiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 14:38:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50568 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaIUSiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 14:38:07 -0400
Message-ID: <541F1AFF.9040509@roeck-us.net>
Date: Sun, 21 Sep 2014 11:37:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikael Starvik <mikael.starvik@axis.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info for
 uniprocessor system"
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net> <1411316838-15135-9-git-send-email-linux@roeck-us.net> <1C04F98F-4DA4-4038-B1D1-930BBC592147@axis.com>
In-Reply-To: <1C04F98F-4DA4-4038-B1D1-930BBC592147@axis.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.541F1B0C.0011,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
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

On 09/21/2014 10:23 AM, Mikael Starvik wrote:
> Thanks for all your work with CRIS! CRISv10 is alive but is currently used as small helper CPUs close to hardware blocks.
>

You are welcome. Now it would be even better if we could get the upstream code to work
with qemu. Which leads to the questions - is CRISv32 alive, and is there a chance
to get there ? Also, if CRISv10 is alive, is there any interest or even benefit to
maintain it in the latest kernel ? Because if not, we might as well drop v10 support
to simplify kernel maintenance.

Thanks,
Guenter

> Jesper will review and ack.
>
>> 21 sep 2014 kl. 18:27 skrev "Guenter Roeck" <linux@roeck-us.net>:
>>
>> This reverts commit 3189eddbcafcc4d827f7f19facbeddec4424eba8.
>>
>> The commit causes a hang with a crisv32 image. This may be an architecture
>> problem, but at least for now the revert is necessary to be able to boot a
>> crisv32 image.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> mm/percpu.c | 2 --
>> 1 file changed, 2 deletions(-)
>>
>> diff --git a/mm/percpu.c b/mm/percpu.c
>> index da997f9..2139e30 100644
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -1932,8 +1932,6 @@ void __init setup_per_cpu_areas(void)
>>
>>     if (pcpu_setup_first_chunk(ai, fc) < 0)
>>         panic("Failed to initialize percpu areas.");
>> -
>> -    pcpu_free_alloc_info(ai);
>> }
>>
>> #endif    /* CONFIG_SMP */
>> --
>> 1.9.1
>>
>

