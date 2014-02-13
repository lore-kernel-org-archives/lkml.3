Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBMWcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:32:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaBMWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:32:20 -0500
Date: Thu, 13 Feb 2014 17:31:41 -0500
From: Dave Jones <davej@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        rdunlap <rdunlap@infradead.org>, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/1] sys_sysfs: Add CONFIG_SYSFS_SYSCALL
Message-ID: <20140213223141.GA1232@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
	akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>,
	gregkh@linuxfoundation.org
References: <20140213220942.ff2ebaeff3876b7136fa4b10@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213220942.ff2ebaeff3876b7136fa4b10@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:09:42PM +0800, Fabian Frederick wrote:
 > sys_sysfs is an obsolete system call no longer supported by libc ...
 > -This patch adds a default CONFIG_SYSFS_SYSCALL=y
 > -Option can be turned off in expert mode.
 > -cond_syscall added to kernel/sys_ni.c
 > 
 > Signed-off-by: Fabian Frederick <fabf@skynet.be>
 > ---
 >  fs/filesystems.c |  2 ++
 >  init/Kconfig     | 10 ++++++++++
 >  kernel/sys_ni.c  |  1 +
 >  3 files changed, 13 insertions(+)

did anyone ever ship userspace that actually used that syscall ?
Some ancient version of udev that probably doesn't work on a modern kernel anyway maybe ?

I wonder if it's something we can make -ENOSYS unconditionally at some point,
and remove all that code entirely.

	Dave

