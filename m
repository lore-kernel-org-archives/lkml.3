Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaIMN3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 09:29:05 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:59073 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaIMN3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 09:29:04 -0400
Message-ID: <54144672.9060807@roeck-us.net>
Date: Sat, 13 Sep 2014 06:28:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Li RongQing <roy.qing.li@gmail.com>
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        jkosina@suse.cz, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] signal: replace !likely with unlikely!
References: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>	<20140911191830.GA31511@roeck-us.net> <CAJFZqHwsjuw5As6duphrgbzxtwmE2ZqbraNEme88M3hi1WBiRQ@mail.gmail.com> <541416AB.7000808@nod.at>
In-Reply-To: <541416AB.7000808@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5414469E.0103,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 09/13/2014 03:04 AM, Richard Weinberger wrote:
> Am 13.09.2014 04:48, schrieb Li RongQing:
>> I did not test, how to test it?
>
> Compare the object files of both variants to find out whether both create
> semantically equivalent code and whether the un/likely have an effect.
> i.e. objdump -S -d kernel/signal.o
> I guess you can just remove the likely as gcc is smart enough to detect the "goto ret;"
> as an unlikely taken branch.
>
Or just write similar test code and observe the result.

When you are doing that, you might learn that if "(!likely(expression))"
is _not_ the same as "if (unlikely(!expression))".

Guenter

