Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3DLQCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:02:03 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41434 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3DLQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <1356040315.3198.51.camel@shinybook.infradead.org>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
Date: Fri, 12 Apr 2013 18:01:58 +0200
Message-ID: <CAFLxGvxp1ajbGu-+itLbDB38J1asGczJE4tyios3VEJ-vXu0fw@mail.gmail.com>
Subject: Re: [PATCH] x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Thu, Dec 20, 2012 at 10:51 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> +                                 -e s/sun4u/sparc64/ \
>                                   -e s/arm.*/arm/ -e s/sa110/arm/ \
>                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
>                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \

Why is this change needed? Especially the -e s/x86_64/x86.
It causes UML to get build for x86 which is a nasty change
of the default behavior.

Before your change you got a UML kernel for the underlying arch just
by running "make linux ARCH=um".
Now it will always build a x86 UML kernel, also if you run it on
x86_64 and one is forced to override
SUBARCH by hand.

--
Thanks,
//richard
