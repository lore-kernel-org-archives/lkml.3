Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3DWT0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:26:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab3DWT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:26:19 -0400
Date: Tue, 23 Apr 2013 12:26:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        kernel@pengutronix.de
Subject: Re: init-mainc-convert-to-pr_foo.patch is IMHO broken
Message-Id: <20130423122617.c96d332c2b0c41ea6cf82998@linux-foundation.org>
In-Reply-To: <20130423191839.GK15233@pengutronix.de>
References: <20130423191839.GK15233@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013 21:18:39 +0200 Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> Hello,
> 
> init-mainc-convert-to-pr_foo.patch breaks the initcall_debug kernel
> parameter. Before the patch I could add
> 
> 	initcall_debug ignore_loglevel
> 
> to the kernel command line and got some additional output about
> initcalls. Now that init/main.c uses pr_debug instead of
> printk(KERN_DEBUG ...) the interesting statements are not compiled in
> any more.
> 

huh.  pr_debug() is different from all the other pr_foo()s.  I never
noticed that.

This?

--- a/init/main.c~init-mainc-convert-to-pr_foo-fix
+++ a/init/main.c
@@ -9,6 +9,8 @@
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
  */
 
+#define DEBUG
+
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
_

