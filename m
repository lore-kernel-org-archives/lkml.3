Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaLPGzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:55:15 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58826 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLPGzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:55:13 -0500
Message-ID: <548FD746.1050904@roeck-us.net>
Date: Mon, 15 Dec 2014 22:55:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 16
References: <20141216154622.7c2ded16@canb.auug.org.au>	<20141216063549.GA1060@roeck-us.net> <20141215224444.dc7f0f3c.akpm@linux-foundation.org>
In-Reply-To: <20141215224444.dc7f0f3c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010202.548FD750.02F9,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 12/15/2014 10:44 PM, Andrew Morton wrote:
> On Mon, 15 Dec 2014 22:35:49 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
>
>> On Tue, Dec 16, 2014 at 03:46:22PM +1100, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Please do not add any code destined for v3.20 to your linux-next included
>>> trees/branches until after v3.19-rc1 is released.
>>>
>>> Changes since 20141215:
>>>
>>> The infiniband tree gained a conflict against Linus' tree and a build
>>> failure so I used the version from next-20141215.
>>>
>>> The userns tree gained a conflict against the vfs tree.
>>>
>>> The clk tree gained a build failure so I used the version from
>>> next-20141215.
>>>
>>> Non-merge commits (relative to Linus' tree): 3588
>>>   2582 files changed, 123494 insertions(+), 135748 deletions(-)
>>>
>>
>> My metag buildbot test fails with this kernel.
>
> Thanks.  What are the error messages?
>
>
Nothing. It just hangs until killed.

qemu log:
char device redirected to /dev/pts/5
Unable to load ROM!
qemu: terminating on signal 15 from pid 17843

http://server.roeck-us.net:8010/builders/qemu-metag-next/builds/60/steps/qemubuildcommand/logs/stdio

Normally output would be similar to the following.

/opt/buildbot/bin/qemu-system-meta -display none -kernel vmlinux -device da,exit_threads=1 -chardev stdio,id=chan1 -chardev pty,id=chan2 -append "rdinit=/sbin/init"
char device redirected to /dev/pts/29
Unable to load ROM!
Linux version 3.18.0+ (groeck@server.roeck-us.net) (gcc version 4.2.4 (IMG-1.4.0.300)) #5 Mon Dec 15 22:50:31 PST 2014
LNKGET/SET go through cache but CONFIG_METAG_LNKGET_AROUND_CACHE=y
DA present
...

Guenter

