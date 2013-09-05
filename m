Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab3IEJi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:38:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab3IEJiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:38:24 -0400
Message-ID: <5228510C.1020906@suse.cz>
Date: Thu, 05 Sep 2013 11:38:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
In-Reply-To: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.9.2013 23:04, Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Currently, the 'MODULES' symbol is hard-coded to be the default symbol
> that enables/disables tristates, if no other symbol was declared with
> 'option modules'.
> 
> While this used to be needed for the Linux kernel, we now have an
> explicit 'option modules' attached to the 'MODULES' symbol (since
> cset 11097a036), so we no longer need to special-case it in the
> kconfig code.
> 
> Furthermore, kconfig is extensively used out of the Linux kernel, and
> other projects may have another meaning for a symbol named 'MODULES'.
> 
> This patch changes the way we enable/disable tristates: if a symbol was
> found with 'option modules' attached to it, then that symbol controls
> enabling tristates. Otherwise, tristates are disabled, even if a symbol
> named 'MODULES' exists.

Wasn't this change supposed to fix allmodconfig with KCONFIG_ALLCONFIG
(http://lkml.org/lkml/2013/8/8/573)? Or is there still more to do?
Because I'm still getting:

$ touch empty
$ make KCONFIG_ALLCONFIG=empty allmodconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allmodconfig Kconfig
#
# configuration written to .config
#
$ grep MODULES .config
CONFIG_MODULES_USE_ELF_RELA=y
# CONFIG_MODULES is not set
$

Michal
