Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab3EAV4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:56:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783Ab3EAV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:56:08 -0400
Date: Wed, 1 May 2013 23:56:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501215604.GA15623@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
 <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
 <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 02:30:05PM -0700, David Rientjes wrote:
> It's an allnoconfig with HYPERVISOR_GUEST, PARAVIRT, KVM_GUEST, and
> KVM_GUEST_COMMON_OPTIONS enabled.

Hmm:

$ make mrproper
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   include/config
  CLEAN   .config
$ make allnoconfig
  HOSTCC  scripts/basic/fixdep
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allnoconfig Kconfig
#
# configuration written to .config
#
$ make menuconfig				<--- select the options you mention above
  HOSTCC  scripts/kconfig/mconf.o
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf Kconfig
configuration written to .config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

Nada. No warnings.

However, it doesn't build:

arch/x86/built-in.o:(.data+0x2a0): undefined reference to `native_setup_msi_irqs'
arch/x86/built-in.o:(.data+0x2a8): undefined reference to `native_teardown_msi_irq'

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
