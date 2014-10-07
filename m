Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaJGRxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbaJGRxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:53:42 -0400
Date: Tue, 7 Oct 2014 13:52:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V25/5] powerpc/kexec: Use global IND_FLAGS macro
Message-ID: <20141007175248.GG27464@redhat.com>
References: <cover.1412640584.git.geoff@infradead.org>
 <adf97d602657c72f6ee59aefe5d51149159a3e99.1412640584.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adf97d602657c72f6ee59aefe5d51149159a3e99.1412640584.git.geoff@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:21:30AM +0000, Geoff Levand wrote:
> linux/kexec.h now defines an IND_FLAGS macro.  Remove the local powerpc
> definition and use the generic one.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

I think this patch should be merged in previous patch. I guess after
applying patch4, series might not be compilable as there are two
definitions of IND_FLAGS now.

Thanks
Vivek

> ---
>  arch/powerpc/kernel/machine_kexec_64.c | 2 --
>  1 file changed, 2 deletions(-)
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
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
