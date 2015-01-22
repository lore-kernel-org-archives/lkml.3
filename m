Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbbAVDOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:14:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40980 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbAVDOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:14:45 -0500
Message-ID: <54C06B19.8060305@roeck-us.net>
Date: Wed, 21 Jan 2015 19:14:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Mel Gorman <mgorman@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <pmoore@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, davem@davemloft.net
Subject: Re: linux-next: Tree for Jan 20
References: <20150120185308.53f4af4e@canb.auug.org.au> <20150120202642.GA6178@roeck-us.net> <20150120225443.GA19629@node.dhcp.inet.fi> <54BF1785.7040300@roeck-us.net> <20150121104325.GA22449@node.dhcp.inet.fi>
In-Reply-To: <20150121104325.GA22449@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54C06B24.0044,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/21/2015 02:43 AM, Kirill A. Shutemov wrote:

>> BUG: Bad page state in process init.sh  pfn:00000
>> page:f05e7460 count:0 mapcount:-1 mapping:  (null) index:0x0
>> flags: 0x400(reserved)
>> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>> bad because of flags:
>> flags: 0x400(reserved)
>> CPU: 0 PID: 1 Comm: init.sh Not tainted 3.19.0-rc5-next-20150120 #1
>> [f0076010 : bad_page+0xdc/0xfc ] [f00760c0 : free_pages_prepare+0x90/0x1f8 ] [f00775cc : free_hot_cold_page+0x20/0x160 ] [f00919e8 : do_wp_page+0x680/0x6ac ] [f00939f4 : handle_mm_fault+0xc94/0xd08 ] [f0015900 : do_sparc_fault+0xfc/0x3ec ] [f000af90 : srmmu_fault+0x58/0x68 ] [f00e74f4 : load_elf_binary+0x9a8/0xe94 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00e67d0 : load_script+0x214/0x224 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00b11a4 : do_execveat_common+0x434/0x584 ] [f00b1310 : do_execve+0x1c/0x2c ] [f02b50b0 : kernel_init+0x70/0xf0 ] [f000b200 : ret_from_kernel_thread+0xc/0x38 ] [00000000 :   (null) ]
>> Disabling lock debugging due to kernel taint
>> : applet not found
>> Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100
>
> It doesn't make much sense to me. It tries to free page with pfn==0 on
> handling wp-fault. How it got mapped in the first place?
>
If I comment out the added call to vm_normal_page(), the code works fine.
If the call to vm_local_page() is there but everything else from your patch
is commented out, the crash occurs. Also, any log message added to the new
code patch (inside the if statements) is not getting printed, meaning the
new code (besides the call to vm_local_page) is not reached.

I guess that means that something in the call to vm_normal_page() appears
to go wrong. No idea what that might be, though.

Guenter

