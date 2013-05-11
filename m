Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3EKINa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 04:13:30 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63918 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3EKIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 04:13:26 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>, EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Nasty memory corrution v3.9-12555-g2dbd3ca
In-Reply-To: <20130510192747.GA11707@thunk.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Sat, 11 May 2013 12:13:20 +0400
Message-ID: <87y5bm53z3.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013 15:27:47 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> Hmm, since you seem to be able to reproduce the problem reliably, any
> chance you can try bisecting the problem?  I've looked at the commits
> that touch fs/jbd2 and nothing is jumping out at me.
> 
> Also, how many CPU's do you have your system, and what kind of storage
> device were you using when you were running iozone (5400rpm HDD,
> 7200RPM HDD, RAID array, SSD, etc.)?
XFS TOO....
It it definitely just an ext3/4 related issue.
I've run xfstests on xfs and almost immediately have got slub corruption
I use following HEAD: 2dbd3cac87250a0d44e07acc86c4224a08522709

2013-05-11 11:59:30 Slab corruption (Not tainted): xfs_efi_item
start=ffff8802335063f0, len=400^M
2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
2013-05-11 11:59:30 Last user:
[<ffffffffa03ba36f>](xfs_efi_item_free+0x3f/0x50 [xfs])^M
2013-05-11 11:59:30 070: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
jkkkkkkkkkkkkkkk^M
2013-05-11 11:59:30 Single bit error detected. Probably bad RAM.^M
2013-05-11 11:59:30 Run memtest86+ or a similar memory test tool.^M
2013-05-11 11:59:30 Prev obj: start=ffff880233506248, len=400^M
2013-05-11 11:59:30 Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.^M
2013-05-11 11:59:30 Last user:
[<ffffffffa034d7bb>](kmem_zone_alloc+0xbb/0x190 [xfs])^M
2013-05-11 11:59:30 000: 48 62 50 33 02 88 ff ff 48 62 50 33 02 88 ff ff
HbP3....HbP3....^M
2013-05-11 11:59:30 010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................^M
2013-05-11 11:59:30 Next obj: start=ffff880233506598, len=400^M
2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
