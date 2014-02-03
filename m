Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaBCVlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:41:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBCVlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:41:02 -0500
Date: Mon, 3 Feb 2014 13:41:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: Re: [PATCH 4/4] nilfs2: implementation of NILFS_IOCTL_SET_SUINFO
 ioctl
Message-Id: <20140203134101.c56b916544e2475f63227339@linux-foundation.org>
In-Reply-To: <1391446244-1435-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1391446244-1435-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Feb 2014 01:50:44 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> With this ioctl the segment usage entries in the SUFILE can be
> updated from userspace.
> 
> This is useful, because it allows the userspace GC to modify and update
> segment usage entries for specific segments, which enables it to avoid
> unnecessary write operations.
> 
> If a segment needs to be cleaned, but there is no or very little
> reclaimable space in it, the cleaning operation basically degrades to
> a useless moving operation. In the end the only thing that changes is
> the location of the data and a timestamp in the segment usage
> information. With this ioctl the GC can skip the cleaning and update
> the segment usage entries directly instead.
> 
> This is basically a shortcut to cleaning the segment. It is still
> necessary to read the segment summary information, but the writing of
> the live blocks can be skipped if it's not worth it.

Documentation/filesystems/nilfs2.txt should be updated to document the
new ioctl.

Which we're in there, please check that the ioctl documentation is
otherwise complete and up-to-date.  These things have a tendency to
bitrot.

