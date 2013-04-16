Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3DPMVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:21:49 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47426 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3DPMVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130411185632.GA7569@redhat.com>
References: <20130411185632.GA7569@redhat.com>
Date: Tue, 16 Apr 2013 08:21:47 -0400
Message-ID: <CA+5PVA5h79QWXqaBi3WdgnqE1eoxTkejBoF7t=6r1X=oyZAOKA@mail.gmail.com>
Subject: Re: print out hardware name & modules list when we encounter bad page tables.
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 2:56 PM, Dave Jones <davej@redhat.com> wrote:
> Given we have been seeing a lot of reports of page table corruption
> for a while now, perhaps if we print out the hardware name, and list
> of modules loaded, we might see some patterns emerging.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> diff -durpN '--exclude-from=/home/davej/.exclude' /home/davej/src/kernel/git-trees/linux/include/asm-generic/bug.h linux-dj/include/asm-generic/bug.h
> --- linux/include/asm-generic/bug.h     2013-01-04 18:57:12.604282214 -0500
> +++ linux-dj/include/asm-generic/bug.h  2013-02-28 20:04:37.649304147 -0500
> @@ -55,6 +55,8 @@ struct bug_entry {
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
>  #endif
>
> +void print_hardware_dmi_name(void);
> +
>  /*
>   * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>   * significant issues that need prompt attention if they should ever
> diff -durpN '--exclude-from=/home/davej/.exclude' /home/davej/src/kernel/git-trees/linux/kernel/panic.c linux-dj/kernel/panic.c
> --- linux/kernel/panic.c        2013-02-26 14:41:18.544116674 -0500
> +++ linux-dj/kernel/panic.c     2013-02-28 20:04:37.666304115 -0500
> @@ -397,16 +397,22 @@ struct slowpath_args {
>         va_list args;
>  };
>
> -static void warn_slowpath_common(const char *file, int line, void *caller,
> -                                unsigned taint, struct slowpath_args *args)
> +void print_hardware_dmi_name(void)
>  {

This fails to build on arches that define __WARN_TAINT.  Just move the
new function definition above the WANT_WARN_ON_SLOWPATH define and it
should be fine.

josh
