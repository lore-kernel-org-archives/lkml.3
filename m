Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab3GDVPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:15:10 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752932Ab3GDVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:15:08 -0400
Message-ID: <51D5E5D2.8020202@nod.at>
Date: Thu, 04 Jul 2013 23:14:58 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/3] arch/um/Makefile: remove dead code
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com> <1372971797-23518-2-git-send-email-artagnon@gmail.com>
In-Reply-To: <1372971797-23518-2-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.07.2013 23:03, schrieb Ramkumar Ramachandra:
> arch/um/Makefile is included in the toplevel Makefile:495.  Well before
> that, it unconditionally sets $SUBARCH (in Makefile:168) as follows:
> 
>   SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> 				    -e s/sun4u/sparc64/ \
> 				    -e s/arm.*/arm/ -e s/sa110/arm/ \
> 				    -e s/s390x/s390/ -e s/parisc64/parisc/ \
> 				    -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> 				    -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
> 
> It is clearly impossible for $SUBARCH to be set as i386 or x86_64.
> Therefore, any code that checks $SUBARCH against these values is dead
> code.

No.
If you build UML for x86_64 you override SUBARCH.
i.e. make linux ARCH=um SUBARCH=x86_64

> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

NAK.

Thanks,
//richard

