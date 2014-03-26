Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaCZPBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:01:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43248 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaCZPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:00:59 -0400
Message-ID: <5332EBA1.4080701@oracle.com>
Date: Wed, 26 Mar 2014 11:00:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <53189BF8.1010308@oracle.com> <531A7CFD.9030603@oracle.com> <20140310104350.GB28797@quack.suse.cz> <531DC89A.9010601@oracle.com> <53304451.7030800@oracle.com> <20140324214851.GB10057@quack.suse.cz> <5330D15E.2000702@oracle.com> <20140325173340.GB17292@quack.suse.cz> <5331C20F.5010109@oracle.com> <20140325211229.GA27422@quack.suse.cz> <20140326055350.GA21267@redhat.com>
In-Reply-To: <20140326055350.GA21267@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 01:53 AM, Dave Jones wrote:
> On Tue, Mar 25, 2014 at 10:12:29PM +0100, Jan Kara wrote:
>
>   > This fixes an oops triggered by trinity when it tried mounting
>   > anon_inodefs which overwrote anon_inode_inode pointer while other CPU
>   > has been in anon_inode_getfile() between ihold() and d_instantiate().
>   > Thus effectively creating dentry pointing to an inode without holding a
>   > reference to it.
>
> <raises eyebrows>
>
> Sasha, do you have changes to trinity's syscall/mount.c ?
> It's kind of miraculous we managed to get the type arg right
> there, because right now we're just passing a random address as an arg.
> The only way that could work is if we randomly managed to do an allocation,
> and then a seek & read from /proc/filesystems to that buffer.  If you're
> lucky enough to get all those conditions right from rand() calls, you should
> probably give up on kernel hacking and buy some powerball tickets.
>
> We should add some code to make that only return strings from /proc/filesystems,
> which makes me wonder if you already did that..

Almost :)

I'm mounting every filesystem under /prov/filesystems into trinity's victims path
before trinity starts, so it gets to fuzz every filesystem known to the kernel.

For nodev filesystems it just mounts then and for nodev ones it will try to
mkfs.$fs a block device and mount that.

So basically I'm not surprised by the explanation for that bug or that trinity
has triggered it.


Thanks,
Sasha


