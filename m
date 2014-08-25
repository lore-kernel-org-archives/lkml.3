Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaHYRxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbaHYRxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:53:46 -0400
Date: Mon, 25 Aug 2014 13:52:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] kexec: Add bit definitions for kimage entry flags
Message-ID: <20140825175256.GF14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
 <b13fc1b6d923e7063746f34968bd2f1c4cb09002.1408731991.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b13fc1b6d923e7063746f34968bd2f1c4cb09002.1408731991.git.geoff@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> Define new kexec preprocessor macros IND_*_BIT that define the bit position of
> the kimage entry flags.  Change the existing IND_* flag macros to be defined as
> bit shifts of the corresponding IND_*_BIT macros.  Also wrap all C language code
> in kexec.h with #if !defined(__ASSEMBLY__) so assembly files can include kexec.h
> to get the IND_* and IND_*_BIT macros.
> 
> Some CPU instruction sets have tests for bit position which are convenient in
> implementing routines that operate on the kimage entry list.  The addition of
> these bit position macros in a common location will avoid duplicate definitions
> and the chance that changes to the IND_* flags will not be propagated to
> assembly files.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  include/linux/kexec.h | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 4b2a0e1..8c628ca 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -1,6 +1,18 @@
>  #ifndef LINUX_KEXEC_H
>  #define LINUX_KEXEC_H
>  
> +#define IND_DESTINATION_BIT 0
> +#define IND_INDIRECTION_BIT 1
> +#define IND_DONE_BIT        2
> +#define IND_SOURCE_BIT      3
> +
> +#define IND_DESTINATION  (1 << IND_DESTINATION_BIT)
> +#define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
> +#define IND_DONE         (1 << IND_DONE_BIT)
> +#define IND_SOURCE       (1 << IND_SOURCE_BIT)
> +
> +#if !defined(__ASSEMBLY__)
> +
>  #include <uapi/linux/kexec.h>
>  
>  #ifdef CONFIG_KEXEC
> @@ -64,10 +76,6 @@
>   */
>  
>  typedef unsigned long kimage_entry_t;
> -#define IND_DESTINATION  0x1
> -#define IND_INDIRECTION  0x2
> -#define IND_DONE         0x4
> -#define IND_SOURCE       0x8
>  
>  struct kexec_segment {
>  	/*
> @@ -312,4 +320,7 @@ struct task_struct;
>  static inline void crash_kexec(struct pt_regs *regs) { }
>  static inline int kexec_should_crash(struct task_struct *p) { return 0; }
>  #endif /* CONFIG_KEXEC */
> +
> +#endif /* !defined(__ASSEBMLY__) */
> +
>  #endif /* LINUX_KEXEC_H */
> -- 
> 1.9.1
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
