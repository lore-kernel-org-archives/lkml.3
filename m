Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3KANkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:40:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47076 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855Ab3KANkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:40:13 -0400
Date: Fri, 1 Nov 2013 09:40:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 1/5] trace-cmd/listen: Remove use of
 sighandler_t
Message-ID: <20131101094006.68b43eda@gandalf.local.home>
In-Reply-To: <20131028154541.GB18282@thinkpad-t410>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
	<1382642074-15567-2-git-send-email-seth.forshee@canonical.com>
	<20131024203007.GB8006@thinkpad-t410>
	<20131028154541.GB18282@thinkpad-t410>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 10:45:41 -0500
Seth Forshee <seth.forshee@canonical.com> wrote:

> 
> >From 20ec8510d0ca2ac789b1ca9cf7b0a6dc2d02f14c Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Mon, 28 Oct 2013 08:15:59 -0500
> Subject: [PATCH] Makefile: Ensure _GNU_SOURCE really is always defined
> 
> When CLFAGS is set with a command argument a normal variable
> assignment is not sufficient to ensure that _GNU_SOURCE will be
> defined. Since this really is critical for building, use an
> override directive when adding it to CFLAGS to ensure that it
> really does get defined in all cases.

Can you send this as a separate patch please. New patches should not
be replies. You can reply to a patch with a patch, but please change
the subject when you do so.

Thanks,

-- Steve

> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 1d613c4..a2ba385 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -223,7 +223,7 @@ CFLAGS ?= -g -Wall
>  LDFLAGS ?=
>  
>  # Required CFLAGS
> -CFLAGS += -D_GNU_SOURCE
> +override CFLAGS += -D_GNU_SOURCE
>  
>  ifndef NO_PTRACE
>  ifneq ($(call try-cc,$(SOURCE_PTRACE),),y)

