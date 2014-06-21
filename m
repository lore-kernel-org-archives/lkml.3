Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaFUH3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 03:29:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60904 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbaFUH27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 03:28:59 -0400
Date: Sat, 21 Jun 2014 15:28:52 +0800
From: Real Name <enjoymindful@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove csum_partial_copy_generic_i386 to clean up
 exception table
Message-ID: <20140621072852.GA6538@name>
References: <538F275B.7000508@nod.at>
 <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
 <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
 <5390E5FD.5030400@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5390E5FD.5030400@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 11:49:49PM +0200, Richard Weinberger wrote:
> Am 05.06.2014 06:15, schrieb Honggang Li:
> > arch/x86/um/checksum_32.S had been copy & paste from x86. When build
> > x86 uml, csum_partial_copy_generic_i386 mess up the exception table.
> > In fact, exception table dose not work in uml kernel.
> 
> Are you sure that exception tables do not work on UML?
> I said, I'm not sure. Can you please find out?

Hi,
 After traced i386 uml kernel with gdb , I'm sure exception tables 
do *not* work. When csum_partial_copy_generic_i386 read user space memory, 
an access error exception arises, however, the segv function always
return zero. So, the fixup nerver executed. The uml system hang (not
kernel panic).

thanks.

> 
> In arch/um/kernel/trap.c:segv() we have the mechanism for it:
>         else if (!is_user && arch_fixup(ip, regs))
>                 goto out;
> 
> The interesting question is, is this by design or was it just copy&pasted from x86
> many moons ago? :)
> 
> > And csum_partial_copy_generic_i386 never been called. So, delete it.
> 
> I like such clean ups. :-)
> 
> Thanks,
> //richard
