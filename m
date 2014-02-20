Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBTAuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:50:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaBTAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:50:08 -0500
Date: Wed, 19 Feb 2014 19:50:07 -0500 (EST)
Message-Id: <20140219.195007.1409896950208101052.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: fix build failure for
 arch_jump_label_transform
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392317864-24746-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392317864-24746-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 16:50:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 13 Feb 2014 13:57:44 -0500

> In arch/sparc/Kernel/Makefile, we see:
> 
>    obj-$(CONFIG_SPARC64)   += jump_label.o
> 
> However, the Kconfig selects HAVE_ARCH_JUMP_LABEL unconditionally
> for all SPARC.  This in turn leads to the following failure when
> doing allmodconfig coverage builds:
> 
> kernel/built-in.o: In function `__jump_label_update':
> jump_label.c:(.text+0x8560c): undefined reference to `arch_jump_label_transform'
> kernel/built-in.o: In function `arch_jump_label_transform_static':
> (.text+0x85cf4): undefined reference to `arch_jump_label_transform'
> make: *** [vmlinux] Error 1
> 
> Change HAVE_ARCH_JUMP_LABEL to be conditional on SPARC64 so that it
> matches the Makefile.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied.
