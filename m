Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3DXUEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:04:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3DXUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:04:44 -0400
Date: Wed, 24 Apr 2013 13:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        zhangwei (Jovi) <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH] re-order CONFIG_EXPERT options to fix menuconfig
 display
Message-Id: <20130424130443.7f78a5d78a59d7ed9968cc90@linux-foundation.org>
In-Reply-To: <1366652378-29558-1-git-send-email-vapier@gentoo.org>
References: <1366652378-29558-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 13:39:38 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> The kconfig language requires that dependent options all follow the
> menuconfig symbol in order to be collapsed below it.  Recently some
> hidden options were added below the EXPERT menuconfig, but did not
> depend on EXPERT (because hidden options can't).  This broke the
> display.  So re-order all these options, and while we're here stick
> the PCI quirks under the EXPERT menu (since it isn't sitting with
> any related options).
> 
> Before this commit, we get:
> 	[*] Configure standard kernel features (expert users)  --->
> 	[ ] Sysctl syscall support
> 	[*] Load all symbols for debugging/ksymoops
> 	...
> 	[ ] Embedded system
> 
> Now we get the older (and correct) behavior:
> 	[*] Configure standard kernel features (expert users)  --->
> 	[ ] Embedded system
> And if you go into the expert menu you get the expert options:
> 	[ ] Sysctl syscall support
> 	[*] Load all symbols for debugging/ksymoops
> 	...
> 

This doesn't work as advertised when I graft it on top of
http://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-make-expert-as-config-instead-of-menuconfig.patch
(generally, assuming that next==mainline when we're at -rc8 is a low
percentage move).

I think I'll drop
init-kconfig-make-expert-as-config-instead-of-menuconfig.patch and take
this one, but could everyone please review everything?


