Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaKLXHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:07:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:45740 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbaKLXH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:07:29 -0500
Message-ID: <1415833605.5124.50.camel@kernel.crashing.org>
Subject: Re: [PATCH V3] kexec: Add IND_FLAGS macro
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geoff Levand <geoff@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 13 Nov 2014 10:06:45 +1100
In-Reply-To: <1415820588.15847.6.camel@smoke>
References: <cover.1412640584.git.geoff@infradead.org>
	 <adf97d602657c72f6ee59aefe5d51149159a3e99.1412640584.git.geoff@infradead.org>
	 <20141007175248.GG27464@redhat.com> <1415820588.15847.6.camel@smoke>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 11:29 -0800, Geoff Levand wrote:
> Add a new kexec preprocessor macro IND_FLAGS, which is the bitwise OR of
> all the possible kexec IND_ kimage_entry indirection flags.  Having this
> macro allows for simplified code in the processing of the kexec
> kimage_entry items.  Also, remove the local powerpc definition and use
> the generic one.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> Hi Ben,
> 
> Could you give your ack on this, then I'll try to get it
> merged with my other kexec patches.
> 
> Thanks.
> 
> -Geoff
> 
>  arch/powerpc/kernel/machine_kexec_64.c | 2 --
>  include/linux/kexec.h                  | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
> index 879b3aa..75652a32 100644
> --- a/arch/powerpc/kernel/machine_kexec_64.c
> +++ b/arch/powerpc/kernel/machine_kexec_64.c
> @@ -96,8 +96,6 @@ int default_machine_kexec_prepare(struct kimage *image)
>  	return 0;
>  }
>  
> -#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
> -
>  static void copy_segments(unsigned long ind)
>  {
>  	unsigned long entry;
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 25e039c..b23412c 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -10,6 +10,7 @@
>  #define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
>  #define IND_DONE         (1 << IND_DONE_BIT)
>  #define IND_SOURCE       (1 << IND_SOURCE_BIT)
> +#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
>  
>  #if !defined(__ASSEMBLY__)
>  


