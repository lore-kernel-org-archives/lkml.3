Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaDMLsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 07:48:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaDMLsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 07:48:07 -0400
Date: Sun, 13 Apr 2014 13:47:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/platform: fix "make O=dir kvmconfig"
Message-ID: <20140413114754.GC25088@pd.tnic>
References: <1397377568-8375-1-git-send-email-borneo.antonio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397377568-8375-1-git-send-email-borneo.antonio@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 04:26:08PM +0800, Antonio Borneo wrote:
> Running:
> 	make O=dir x86_64_defconfig
> 	make O=dir kvmconfig
> the second command dirties the source tree with file ".config",
> symlink "source" and objects in folder "scripts".
> 
> Fixed by adding paths in arch Makefile.
> 
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>

Yes, without this patch and building into another dir with O=, kvmconfig
has more problems:

$ make O=/tmp/kernel kvmconfig
Using /tmp/kernel/.config as base
Merging arch/x86/configs/kvm_guest.config
sed: can't read arch/x86/configs/kvm_guest.config: No such file or directory
cat: arch/x86/configs/kvm_guest.config: No such file or directory
#
# merged configuration written to /tmp/kernel/.config (needs make)
#
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config

So, yes, we want it:

Acked-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
