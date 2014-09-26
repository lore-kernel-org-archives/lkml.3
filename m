Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbaIZV2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:28:54 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62123 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201AbaIZV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140926205817.GQ7996@ZenIV.linux.org.uk>
References: <20140914194738.GS7996@ZenIV.linux.org.uk>
	<CAGhQ9Vx26RQWErODdJ_fV5UnAQ8wLre_x-4E6N_vuP0uExyKgw@mail.gmail.com>
	<20140926205817.GQ7996@ZenIV.linux.org.uk>
Date: Fri, 26 Sep 2014 23:28:50 +0200
Message-ID: <CAGhQ9VzQf2Oa06hOP6MC-qR9F7xF_C7omuubkH+9GcLqxkfX3w@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Joachim Eastwood <manabian@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 22:58, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 26, 2014 at 10:46:14PM +0200, Joachim Eastwood wrote:
>> On 14 September 2014 21:47, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > double iput() on failure exit in lustre, racy removal of spliced dentries
>> > from ->s_anon in __d_materialise_dentry() plus a bunch of assorted RCU pathwalk
>> > fixes.  Please, pull from the usual place -
>> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>> >
>> > Shortlog:
>> > Al Viro (5):
>> >       [fix] lustre: d_make_root() does iput() on dentry allocation failure
>> >       move the call of __d_drop(anon) into __d_materialise_unique(dentry, anon)
>> >       fix bogus read_seqretry() checks introduced in b37199e
>> >       don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
>> >       be careful with nd->inode in path_init() and follow_dotdot_rcu()
>>
>> Hi,
>>
>> Commit 4023bfc9f351a7994 "be careful with nd->inode in path_init() and
>> follow_dotdot_rcu(), seem to hang my ARM no-MMU platform when mounting
>> the ramdisk.
>>
>> 3.17-rc4 - works
>> 3.17-rc5 - works with 4023bfc9f351a7994 reverted.
>>
>> Boot log with from rc5:
>> [ 5.810000] TCP: cubic registered
>> [ 5.820000] NET: Registered protocol family 17
>> [ 5.860000] lpc2k-rtc 40046000.rtc: hctosys: unable to read the hardware clock
>> [ 5.910000] mmc_host mmc0: Bus speed (slot 0) = 12000000Hz (slot req
>> 25000000Hz, actual 12000000HZ div = 0)
>> [ 5.930000] mmc0: new SDHC card at address 0007
>> [ 5.950000] mmcblk0: mmc0:0007 SD08G 7.42 GiB
>> [ 6.150000] clk: Not disabling unused clocks
>> [ 81.240000] random: nonblocking pool is initialized
>>
>> And there it just hangs it seems.
>>
>>
>> With patch reverted
>> [ 5.810000] TCP: cubic registered
>> [ 5.820000] NET: Registered protocol family 17
>> [ 5.850000] lpc2k-rtc 40046000.rtc: hctosys: unable to read the hardware clock
>> [ 6.100000] clk: Not disabling unused clocks
>> [ 6.110000] RAMDISK: gzip image found at block 0
>> [ 9.590000] VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
>> [ 9.600000] devtmpfs: mounted
>> [ 9.610000] Freeing unused kernel memory: 68K (281e5000 - 281f6000)
>>
>> And then user space starts.
>
> *blink*  What happens to mmc-related messages on successful boot?  And what
> in that commit could've possibly lead to those not being produced?

Now I am puzzled too. I can not longer reproduce that hang.

I am guessing it was probably related to the mmc card being flaky or
something random like that.

Sorry for noise!

regards,
Joachim Eastwood
