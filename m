Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3BDN4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:56:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49713 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3BDN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:56:34 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <20130204183926.f5d5ab14b0ae4d22cb253202@canb.auug.org.au>
References: <20130204183926.f5d5ab14b0ae4d22cb253202@canb.auug.org.au>
Date: Mon, 4 Feb 2013 13:56:32 +0000
X-Google-Sender-Auth: OeakWBZ82LeoFQ22ml2abv_Zewc
Message-ID: <CAAG0J99hxOOGh74wQ2R47o0noRxQhNS8T_DNnbX2FX-rJ2wMzQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 4
From: James Hogan <james.hogan@imgtec.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 4 February 2013 07:39, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Merging signal/for-next (9005965 x86: convert to ksignal)
> CONFLICT (content): Merge conflict in arch/x86/Kconfig

I think this conflict has been resolved incorrectly.

Al's commit 1820f96 "burying unused conditionals" removed
GENERIC_SIGALTSTACK from config X86, but the merge
(c5395e2affed5c42200cb6e21e3380995ef22ae3) left GENERIC_SIGALTSTACK
in:

diff --cc arch/x86/Kconfig
index 32d4ff1,49fb44e..6979498
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -114,9 -113,9 +114,12 @@@ config X8
  	select MODULES_USE_ELF_REL if X86_32
  	select MODULES_USE_ELF_RELA if X86_64
  	select CLONE_BACKWARDS if X86_32
 +	select ARCH_USE_BUILTIN_BSWAP
 +	select GENERIC_SIGALTSTACK
 +	select ARCH_USE_BUILTIN_BSWAP
+ 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
+ 	select OLD_SIGACTION if X86_32
+ 	select COMPAT_OLD_SIGACTION if IA32_EMULATION

  config INSTRUCTION_DECODER
  	def_bool y

Cheers
James
