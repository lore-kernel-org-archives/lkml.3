Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbaGOKx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:53:59 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:60101 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbaGOKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:53:55 -0400
Message-ID: <53C50840.2020204@imgtec.com>
Date: Tue, 15 Jul 2014 11:53:52 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 35/38] unicore32: clean-up uapi Kbuild file
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-35-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-35-git-send-email-sam@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 16:09, Sam Ravnborg wrote:
> Remove redundant assignments.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/uapi/asm/Kbuild | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/unicore32/include/uapi/asm/Kbuild b/arch/unicore32/include/uapi/asm/Kbuild
> index 0514d7a..aff532f 100644
> --- a/arch/unicore32/include/uapi/asm/Kbuild
> +++ b/arch/unicore32/include/uapi/asm/Kbuild
> @@ -1,10 +1,5 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -header-y += byteorder.h
> -header-y += kvm_para.h
> -header-y += ptrace.h
> -header-y += sigcontext.h
> -header-y += unistd.h
> -
> +# Wapper from asm-generic
>  generic-y += kvm_para.h
> 

You dropped the generic-y += kvm_para.h for arm64 & c6x, but not for
unicore, avr32 & ia64 patch, which seems a bit inconsistent. Was there
some reason behind that?

AFACT the non-uapi kvm_para.h is needed (e.g. by using the generic
non-uapi one) by kernel/watchdog.c for
kvm_check_and_clear_guest_paused(), so all arches should have at least
generic-y += kvm_para.h (or their own one) for non-uapi, even if they
have a uapi one too.

For UAPI, they're presumably only needed for architectures which support
KVM (s390, ia64, arm, powerpc, arm64, mips, x86 all provide an asm/kvm.h).

Is that right? Clearly there's some cleanup to do for kvm_para.h (which
is what made me look at the header issues previously).

Cheers
James
