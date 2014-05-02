Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaEBUlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:41:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:53131 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752136AbaEBUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:41:51 -0400
Date: Fri, 2 May 2014 16:41:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] plist: include -DDEBUG if CONFIG_DEBUG_PI_LIST
Message-ID: <20140502164148.44c0674b@gandalf.local.home>
In-Reply-To: <1399062223-18928-1-git-send-email-ddstreet@ieee.org>
References: <1399062223-18928-1-git-send-email-ddstreet@ieee.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 May 2014 16:23:43 -0400
Dan Streetman <ddstreet@ieee.org> wrote:

> lib/plist.c uses pr_debug() in its test function, which is compiled
> and run only when CONFIG_DEBUG_PI_LIST in set; however pr_debug()
> is compiled out unless -DDEBUG is set for the file.
> 
> Update lib/Makefile to add -DDEBUG to CFLAGS_plist.o if
> CONFIG_DEBUG_PI_LIST is set, so that the pr_debug() output from
> plist_test() is shown.

Why not just use printk(KERN_DEBUG ...) then if we always want to print
it?

You could just place

#define DEBUG

in plist.c as well. Although I think just switching to printk() is
better.

-- Steve

> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> ---
>  lib/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index 0cd7b68..fd1f4c8 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -39,6 +39,10 @@ CFLAGS_kobject.o += -DDEBUG
>  CFLAGS_kobject_uevent.o += -DDEBUG
>  endif
>  
> +ifeq ($(CONFIG_DEBUG_PI_LIST),y)
> +CFLAGS_plist.o += -DDEBUG
> +endif
> +
>  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
>  obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
>  obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o

