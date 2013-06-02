Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3FBKVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:21:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60208 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab3FBKVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:21:25 -0400
Date: Sun, 2 Jun 2013 12:21:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, amd64-microcode@amd64.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Cocci spatch "memdup.spatch"
Message-ID: <20130602102137.GA3441@nazgul.tnic>
References: <1370079731.29224.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370079731.29224.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 11:42:11AM +0200, Thomas Meyer wrote:
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -345,7 +345,7 @@ static int verify_and_add_patch(unsigned
>  		return -EINVAL;
>  	}
>  
> -	patch->data = kzalloc(patch_size, GFP_KERNEL);
> +	patch->data = kmemdup(fw + SECTION_HDR_SIZE, patch_size, GFP_KERNEL);
>  	if (!patch->data) {
>  		pr_err("Patch data allocation failure.\n");
>  		kfree(patch);
> @@ -353,7 +353,6 @@ static int verify_and_add_patch(unsigned
>  	}
>  
>  	/* All looks ok, copy patch... */
> -	memcpy(patch->data, fw + SECTION_HDR_SIZE, patch_size);
>  	INIT_LIST_HEAD(&patch->plist);
>  	patch->patch_id  = mc_hdr->patch_id;
>  	patch->equiv_cpu = proc_id;

I can see what happens with a little code browsing of the definition of
kmemdup but patches without a commit message are most times not a very
elegant thing.

So please add a nice commit message explaining why you're doing what
you're doing. If the coccinelle script is not in the kernel tree,
then referring to it doesn't mean a whole lot so don't do it. Rather,
explaining why you're doing the change, is a much better thing to do.

Thanks.
