Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHOPmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:42:53 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:61526 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <1408093066-31021-1-git-send-email-stefan.bader@canonical.com>
References: <1408093066-31021-1-git-send-email-stefan.bader@canonical.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 08:42:30 -0700
Message-ID: <CALCETrV048o-6nKK3TJXf=mdjARO=KKmbCxAVMYTGPffGNX-vQ@mail.gmail.com>
Subject: Re: [PATCH] x86_32, entry: Clean up sysenter_badsys declaration
To: Stefan Bader <stefan.bader@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 1:57 AM, Stefan Bader
<stefan.bader@canonical.com> wrote:
> commit 554086d85e "x86_32, entry: Do syscall exit work on badsys
> (CVE-2014-4508)" introduced a new jump label (sysenter_badsys) but
> somehow the END statements seem to have gone wrong (at least it
> feels that way to me).
> This does not seem to be a fatal problem, but just for the sake
> of symmetry, change the second syscall_badsys to sysenter_badsys.

Acked-by: Andy Lutomirski <luto@amacapital.net>

hpa, can you pick up one of the several variants of this patch that
are floating around?  AFAIK nothing cares about the sizes of these
symbols, but the current code is clearly wrong even if it's harmless.

--Andy

>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  arch/x86/kernel/entry_32.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 47c410d..4b0e1df 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -683,7 +683,7 @@ END(syscall_badsys)
>  sysenter_badsys:
>         movl $-ENOSYS,%eax
>         jmp sysenter_after_call
> -END(syscall_badsys)
> +END(sysenter_badsys)
>         CFI_ENDPROC
>
>  .macro FIXUP_ESPFIX_STACK
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
