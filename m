Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaBDBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:48:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:59867 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaBDBsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:48:10 -0500
Date: Tue, 04 Feb 2014 10:47:56 +0900 (JST)
Message-Id: <20140204.104756.212377853.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: Re: [PATCH 4/4] nilfs2: implementation of NILFS_IOCTL_SET_SUINFO
 ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20140203134101.c56b916544e2475f63227339@linux-foundation.org>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1391446244-1435-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140203134101.c56b916544e2475f63227339@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 10:47:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014 13:41:01 -0800, Andrew Morton wrote:
> On Tue,  4 Feb 2014 01:50:44 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> With this ioctl the segment usage entries in the SUFILE can be
>> updated from userspace.
>> 
>> This is useful, because it allows the userspace GC to modify and update
>> segment usage entries for specific segments, which enables it to avoid
>> unnecessary write operations.
>> 
>> If a segment needs to be cleaned, but there is no or very little
>> reclaimable space in it, the cleaning operation basically degrades to
>> a useless moving operation. In the end the only thing that changes is
>> the location of the data and a timestamp in the segment usage
>> information. With this ioctl the GC can skip the cleaning and update
>> the segment usage entries directly instead.
>> 
>> This is basically a shortcut to cleaning the segment. It is still
>> necessary to read the segment summary information, but the writing of
>> the live blocks can be skipped if it's not worth it.
> 
> Documentation/filesystems/nilfs2.txt should be updated to document the
> new ioctl.
> 
> Which we're in there, please check that the ioctl documentation is
> otherwise complete and up-to-date.  These things have a tendency to
> bitrot.

Got it.  I missed the recent effort by Vyacheslav which added
description on every ioctl in the doucument file.

I'll send a patch for this soon.

Thanks,
Ryusuke Konishi
