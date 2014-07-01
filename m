Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbaGAQtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:49:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41670 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758467AbaGAQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:49:12 -0400
Date: Tue, 1 Jul 2014 17:49:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
Cc: Andrew Pinski <apinski@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few
 syscalls need to be using the compat syscalls.
Message-ID: <20140701164902.GT18313@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-23-git-send-email-apinski@cavium.com>
 <20140701150539.GA18309@arm.com>
 <800835FF-E10A-4C0C-A68F-0ED1434F1CE2@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800835FF-E10A-4C0C-A68F-0ED1434F1CE2@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 04:30:51PM +0100, Pinski, Andrew wrote:
> On Jul 1, 2014, at 8:07 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> > On Sat, May 24, 2014 at 12:02:17AM -0700, Andrew Pinski wrote:
> >> +/* Using Compat syscalls where necessary */
> >> +#define sys_ioctl        compat_sys_ioctl
> >> +/* iovec */
> >> +#define sys_readv        compat_sys_readv
> >> +#define sys_writev        compat_sys_writev
> >> +#define sys_preadv        compat_sys_preadv64
> >> +#define sys_pwritev        compat_sys_pwritev64
> >> +#define sys_vmsplice        compat_sys_vmsplice
> > 
> > Do these actually work? compat_iovec has two members of 32-bit each
> > while the ILP32 iovec has a void * (32-bit) and a __kernel_size_t which
> > is 64-bit.
> 
> size_t should be unsigned long in ilp32 so a 32bit unsigned integer
> type.  That part of the abi was already defined in the arm abi
> documents.  Now are saying we should pass size_t different between
> user and kernel space?

OK, I think you are right here. The ILP32 would not see __kernel_size_t
defined as __kernel_ulong_t because __BITS_PER_LONG != 64.

> >> +/* Pointer in struct */
> >> +#define sys_mount               compat_sys_mount
> > 
> > Which structure is this?
> 
> NFS structure, I can expand out the comment if needed. 

That would be good for future reference.

Thanks.

-- 
Catalin
