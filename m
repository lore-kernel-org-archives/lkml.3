Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBMWnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:43:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaBMWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:43:21 -0500
Date: Thu, 13 Feb 2014 14:43:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        rdunlap <rdunlap@infradead.org>, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/1] sys_sysfs: Add CONFIG_SYSFS_SYSCALL
Message-Id: <20140213144319.3b6f4de46b3a067c3ea53ad3@linux-foundation.org>
In-Reply-To: <20140213223141.GA1232@redhat.com>
References: <20140213220942.ff2ebaeff3876b7136fa4b10@skynet.be>
	<20140213223141.GA1232@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 17:31:41 -0500 Dave Jones <davej@redhat.com> wrote:

> On Thu, Feb 13, 2014 at 10:09:42PM +0800, Fabian Frederick wrote:
>  > sys_sysfs is an obsolete system call no longer supported by libc ...
>  > -This patch adds a default CONFIG_SYSFS_SYSCALL=y
>  > -Option can be turned off in expert mode.
>  > -cond_syscall added to kernel/sys_ni.c
>  > 
>  > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>  > ---
>  >  fs/filesystems.c |  2 ++
>  >  init/Kconfig     | 10 ++++++++++
>  >  kernel/sys_ni.c  |  1 +
>  >  3 files changed, 13 insertions(+)
> 
> did anyone ever ship userspace that actually used that syscall ?
> Some ancient version of udev that probably doesn't work on a modern kernel anyway maybe ?
> 
> I wonder if it's something we can make -ENOSYS unconditionally at some point,
> and remove all that code entirely.

Perhaps we could make it `default n' now and see if we receive nastygrams?
