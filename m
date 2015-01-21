Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbbAURvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:51:32 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:48409 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbAURvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:51:25 -0500
Message-ID: <54BFE713.20807@roeck-us.net>
Date: Wed, 21 Jan 2015 09:51:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Paul Moore <pmoore@redhat.com>
CC: Sabrina Dubroca <sd@queasysnail.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
References: <20150120165655.GA10904@kria> <20150121153910.GD22884@ulmo.nvidia.com> <20150121155407.GA18701@kria> <6942214.D1ODllqz3j@sifl> <20150121173810.GP29656@ZenIV.linux.org.uk>
In-Reply-To: <20150121173810.GP29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54BFE71D.000D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/21/2015 09:38 AM, Al Viro wrote:
> On Wed, Jan 21, 2015 at 11:16:23AM -0500, Paul Moore wrote:
>> On Wednesday, January 21, 2015 04:54:07 PM Sabrina Dubroca wrote:
>>> 2015-01-21, 16:39:12 +0100, Thierry Reding wrote:
>>>> That doesn't seem to help, at least in my case.
>>>
>>> Same here.
>>
>> Okay, thanks for trying.  Sorry that didn't resolve things.
>>
>>> Well, it's probably not an audit issue.  I tried audit=0 on the
>>> commandline, and I just rebuilt a kernel with CONFIG_AUDIT=n, and it's
>>> still panicing.  This should have fixed any audit-related issue,
>>> right?
>>
>> Most likely.  Back to the code I go ...
>
> FWIW, I really wonder if populate_rootfs() (run ultimately from
> kernel_init(), by way of kernel_init_freeable(), do_basic_setup() and
> do_initcalls()) ends up with some side effects as far as struct filename
> are concerned...
>
> Note that if we _ever_ hit reuse logics there, we are going to get bogus
> matches asoddingplenty - *all* those sys_mkdir(), etc. are going to be
> with filenames in the same reused buffer.  So if anything in there leaks
> from one call to another, we are going to have a mess on hands.
>
> Another place where that can be a problem is devtmpfs - there's a kernel
> thread doing actual mkdir, mknod, etc. in that abomination and if _that_
> ends up accumulating aushit entries, we'll end up with interesting problems.
>
> Folks, could you print the value of audit_dummy_context() in populate_rootfs()
> and in drivers/base/devtmpfs.c:devtmpfsd()?
>
populate_rootfs: audit_dummy_context() returns 1

Guenter

