Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaIZNcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:32:55 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:42678 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaIZNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:32:52 -0400
Message-ID: <54256AF1.6030800@roeck-us.net>
Date: Fri, 26 Sep 2014 06:32:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux <linux@openrisc.net>,
        Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: New build failures in Sep 25 tree
References: <20140925202559.GA1750@roeck-us.net> <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com> <20140926075859.GA21697@chokladfabriken.org>
In-Reply-To: <20140926075859.GA21697@chokladfabriken.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54256B04.00C6,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 09/26/2014 12:59 AM, Stefan Kristiansson wrote:
> On Fri, Sep 26, 2014 at 08:30:57AM +0200, Geert Uytterhoeven wrote:
>> Hi Günther,
>>
>> [cc openrisc]
>>
>> On Thu, Sep 25, 2014 at 10:25 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> New build failures:
>>
>>> openrisc-defconfig
>>>
>>> In file included from arch/openrisc/kernel/signal.c:31:0:
>>> ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
>>> ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
>>
>> That's not a new one. It's been failing for half or year or so.
>>
>> If you only see it now, that means something else got fixed ;-)
>>
>
>>From what I can see, it's caused by
> ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> that got (re?)introduced two days ago.
>
> To me it seems that the problem is that EM_OPENRISC is
> missing in include/uapi/linux/elf-em.h, but if that's the case,
> I think microblaze have the same problem with that patch applied.
>

Microblaze builds for some reason. But, yes, that commit is from March.
Maybe that is where I remember it from.

You are right, it builds if I add the define. I'll submit a patch to fix
the problem if the resulting image builds.

Guenter

