Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaHKRPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:15:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35939 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbaHKRP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:15:28 -0400
Date: Mon, 11 Aug 2014 18:15:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
Message-ID: <20140811171511.GF8828@arm.com>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
 <1407764228-7904-2-git-send-email-will.deacon@arm.com>
 <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 05:54:08PM +0100, David Herrmann wrote:
> On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> > Commit 9183df25fe7b ("shm: add memfd_create() syscall") added a new
> > system call (memfd_create) but didn't update the asm-generic unistd
> > header.
> >
> > This patch adds the new system call to the asm-generic version of
> > unistd.h so that it can be used by architectures such as arm64.
> >
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: David Herrmann <dh.herrmann@gmail.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks, David.

Arnd: shall I take this via the arm64 tree, or do you already have some
asm-generic patches queued?

Will

> > ---
> >  include/uapi/asm-generic/unistd.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> > index f1afd607f043..11d11bc5c78f 100644
> > --- a/include/uapi/asm-generic/unistd.h
> > +++ b/include/uapi/asm-generic/unistd.h
> > @@ -703,9 +703,11 @@ __SYSCALL(__NR_renameat2, sys_renameat2)
> >  __SYSCALL(__NR_seccomp, sys_seccomp)
> >  #define __NR_getrandom 278
> >  __SYSCALL(__NR_getrandom, sys_getrandom)
> > +#define __NR_memfd_create 279
> > +__SYSCALL(__NR_memfd_create, sys_memfd_create)
> >
> >  #undef __NR_syscalls
> > -#define __NR_syscalls 279
> > +#define __NR_syscalls 280
> >
> >  /*
> >   * All syscalls below here should go away really,
> > --
> > 2.0.1
> >
> 
