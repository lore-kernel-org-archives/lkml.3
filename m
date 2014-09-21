Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaIUQsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:48:12 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:39259 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaIUQsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:48:10 -0400
Message-ID: <541F013D.7050507@roeck-us.net>
Date: Sun, 21 Sep 2014 09:47:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Jesper Nilsson <jespern@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
References: <20140831175010.GA15408@roeck-us.net> <20140915145203.GK4659@axis.com> <20140917190753.GA13115@roeck-us.net> <20140918085249.GS4659@axis.com>
In-Reply-To: <20140918085249.GS4659@axis.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.541F014A.0076,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/18/2014 01:52 AM, Jesper Nilsson wrote:
> On Wed, Sep 17, 2014 at 09:07:53PM +0200, Guenter Roeck wrote:
>> Just to give you an update. I "kind of" got an image to run with qemu
>> after applying the following patches.
>>
>> 8119d33 cris: Add basic qemu_defconfig
>> 40d078b cris: time.c: Add missing include file to fix compile error
>> a4f2390 cris: Add dummy free_initrd_mem
>> 88585aa cris: Add serial driver for Cris v32
>> a38d868 cris: Add support for early console
>>
>> Let me know if you would like a copy of those patches. Out of those, 40d078b,
>> a4f2390, and a38d868 should be pretty much acceptable for upstream integration.
>> 88585aa would need a lot of work (and probably a rewrite).
>
> Yes please, that would be helpful.
>
>> Compiler version is 4.7.4; 4.9.1 builds even after applying a number of upstream
>> patches, but the resulting image hangs. The weekly gcc snapshot fails to build.
>>
>> The configuration is (I believe) derived from the configuration used for the
>> image available from the qemu web site. The same is true for the crisv32
>> serial driver and early console support. time.c needed an additional include
>> file (<linux/mm.h>). free_initrd_mem is needed to be able to build an image
>> with initrd support; it currently does nothing.
>>
>> With this, I am able to get into a shell using a built-in initrd.
>>
>> / # uname -a
>> Linux (none) 3.16.2-00005-g8119d33 #40 Wed Sep 17 11:49:31 PDT 2014 crisv32 GNU/Linux
>>
>> However, I see the following traceback.
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 186 at kernel/softirq.c:146 0xc000fd72()
>> Modules linked in:
>> CPU: 0 PID: 186 Comm: init Not tainted 3.16.2-00005-g8119d33 #40
>>
>> Stack from c1cf9eb0:
>>         00000000 c02569d0 00000009 c0279f80 c1fda770 c1fa3680 c02574d6 c000cbb8
>>         00000092 c000fd72 00000200 c02d0d94 00000000 00000000 c000fd72 00000092
>>         c000cbea 00000000 c000fd72 c1f862d2 c1cdbc20 c01ff768 c1f862d2 c1f862d6
>> Call Trace: [<c02569d0>] [<c02574d6>] [<c000cbb8>] [<c000fd72>] [<c000fd72>] [<c000cbea>] [<c000fd72>]
>>         [<c01ff768>] [<c01ff908>] [<c016f83c>] [<c016fb10>] [<c006cfc0>] [<c025855a>] [<c006d0f4>] [<c001f212>]
>>         [<c0004b80>] [<c00054f0>]
>> ---[ end trace 5bb306335a1f3b62 ]---
>>
>> Manual symbol decode (this is from a 3.10 traceback, so the addresses
>> are a bit different):
>>
>> c0234d8a	printk
>> c0012b0e	local_bh_enable
>> c0236004	dump_stack
>> c000ca4a	warn_slowpath_common
>> c000ca78	warn_slowpath_null
>> c0012b0e	local_bh_enable
>> c01e3c16	unix_release_sock
>> c01e3dae	unix_release
>> c015fb9a	sock_release
>> c015fe68	sock_close
>> c0067fae	__fput
>> c0237a20	_cond_resched
>> c0068168	____fput
>> c0022062	task_work_run
>> c0004954	do_notify_resume
>> c0005324	_work_notifysig
>
>
> I'm not sure if this has happened here, but please note that
> some of the symbols in the stack backtrace might be false,
> since the CRIS does not have true stack unwinding,
> the backtrace code only checks the stack for any
> pointers in the kernel address space and reports them too.
>
>> --> Further debugging shows that interrupts are disabled when this happens.
>>
>> This traceback is seen from 3.10 onwards. 3.4 did not show the traceback; I did
>> not test any releases in between.
>
> Ok thanks, will try to reproduce here.
>

I just sent the series. My suspicion is that you might have some
relevant changes in architecture code which never made it upstream.

Guenter

