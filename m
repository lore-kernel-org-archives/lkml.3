Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaBUUQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:16:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaBUUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:16:29 -0500
Date: Fri, 21 Feb 2014 12:16:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Jiri Slaby <jslaby@suse.cz>,
        Eric Paris <eparis@redhat.com>, Dwight Engen <dwight.engen@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs, kernel: Support disabling the uselib syscall
Message-Id: <20140221121627.19e5d04dbba25984d4be8a15@linux-foundation.org>
In-Reply-To: <20140221181103.GA5773@jtriplet-mobl1>
References: <20140221181103.GA5773@jtriplet-mobl1>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 10:11:06 -0800 Josh Triplett <josh@joshtriplett.org> wrote:

> uselib hasn't been used since libc5; glibc does not use it.  Support
> turning it off.
> 
> When disabled, also omit the load_elf_library implementation from
> binfmt_elf.c, which only uselib invokes.
> 
> bloat-o-meter:
> add/remove: 0/4 grow/shrink: 0/1 up/down: 0/-785 (-785)
> function                                     old     new   delta
> padzero                                       39      36      -3
> uselib_flags                                  20       -     -20
> sys_uselib                                   168       -    -168
> SyS_uselib                                   168       -    -168
> load_elf_library                             426       -    -426
> 

The patch disables CONFIG_USELIB by default.  This important decision
should be mentioned and justified in the changelog, please.

> +#ifdef CONFIG_USELIB

I wonder if CONFIG_SYS_USELIB would be a better identifier.  We haven't
done anything consistent here.


