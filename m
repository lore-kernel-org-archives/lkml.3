Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaGKQPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbaGKQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:15:51 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] [RFC] audit: add AUDIT_ARCH_X86_X32 arch definition
Date: Fri, 11 Jul 2014 12:15:46 -0400
Message-ID: <36980406.O4hutv41J6@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <b6655cee4250a69330ecbc6657a4df0d52ebd7da.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com> <b6655cee4250a69330ecbc6657a4df0d52ebd7da.1405023592.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 11:38:12 PM Richard Guy Briggs wrote:
> Add a definition for 32-bit native system calls under 64-bit x86
> architectures. This is distict from 32-bit emulation under 64-bit x86
> architectures.
> 
> Cc: Paul Moore <pmoore@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Al Viro <aviro@redhat.com>
> Cc: Will Drewry <wad@chromium.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index e15d6fc..4f5607f 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -374,6 +374,7 @@ enum {
>  #define AUDIT_ARCH_SPARC	(EM_SPARC)
>  #define AUDIT_ARCH_SPARC64	(EM_SPARCV9|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_X86_64	(EM_X86_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
> +#define AUDIT_ARCH_X86_X32	(EM_X86_64|__AUDIT_ARCH_LE)
> 
>  #define AUDIT_PERM_EXEC		1
>  #define AUDIT_PERM_WRITE	2

While I'm opposed to the other patches in this series (comments to follow), I 
think this is a worthwhile addition and arguably should have been done when 
x32 was merged.

That said, this change should probably be included in whatever patch first 
makes use of this new value as this patch does nothing by itself.

-- 
paul moore
security and virtualization @ redhat

