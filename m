Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaGCA5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:57:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaGCA5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:57:01 -0400
Date: Wed, 2 Jul 2014 17:56:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: Andi Kleen <ak@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-07-02-15-07 uploaded (stack protector)
Message-Id: <20140702175635.79d54c44.akpm@linux-foundation.org>
In-Reply-To: <20140703005100.GI5412@outflux.net>
References: <53b482d3.gR7nYB/K7hPREviI%akpm@linux-foundation.org>
	<53B493E2.2030905@infradead.org>
	<20140703002231.GR19781@tassilo.jf.intel.com>
	<20140703005100.GI5412@outflux.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 17:51:00 -0700 Kees Cook <kees@outflux.net> wrote:

> > It's hard to tell what the original author wanted, perhaps they wanted
> > it to error out. It looks intentional. Clearly they didn't think of randconfig
> > though.
> 
> The problem is that if you make kbuild hard-fail when selecting this missing
> compiler option, you can never switch it back because "make menuconfig" will
> refuse to build since the compiler option would be missing. Being silent
> about the missing option (and/or falling back to other options) means that
> you could get two different kernel features selection with the same CONFIG_*
> set, depending on the kernel, which is extremely bad ("I selected
> stack-protector-strong but it built without it?!").
> 
> So, the middle ground was to warn about it during the kbuild logic so
> you could find the source of the problem, but ultimately fail the build
> when the compiler doesn't support it so there weren't any silent failure
> modes.

--- a/Makefile~a
+++ a/Makefile
@@ -630,6 +630,9 @@ KBUILD_CFLAGS += $(call cc-option,-Wfram
 endif
 
 # Handle stack protector mode.
+#
+# This space reserved for Kees
+#
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
_

