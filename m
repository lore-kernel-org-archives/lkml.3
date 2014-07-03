Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaGCMZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbaGCMZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:25:04 -0400
Date: Thu, 3 Jul 2014 08:24:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140703122458.GA21156@redhat.com>
References: <20140703145940.002b7056@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703145940.002b7056@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 02:59:40PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> /bin/sh: /scratch/sfr/next/scripts/basic/bin2c: No such file or directory
> 
> Presumably caused by commit 572a8e0147f8 ("bin2c: move bin2c in
> scripts/basic") and commit 1b4c30351f49 ("purgatory: core purgatory
> functionality").  Note that the directory above is the *source*
> directory (I build with O=...).  bin2c is in my object directory (in
> scripts/basicbin2c).
> 
> I have added the following patch for today:

Thanks Stephen. Yes, it should have been objtree instead of srctree. I
do not compile with O=, hence I did not catch it during my testing.

Again, thanks for taking care of this.

Vivek

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 3 Jul 2014 14:56:25 +1000
> Subject: [PATCH] purgatory: run host built programs from objtree
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/purgatory/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index e5829ddbca2b..7fde9ee438a4 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -18,7 +18,7 @@ $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  targets += kexec-purgatory.c
>  
>  quiet_cmd_bin2c = BIN2C   $@
> -      cmd_bin2c = cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
> +      cmd_bin2c = cat $(obj)/purgatory.ro | $(objtree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
>  
>  $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
>  	$(call if_changed,bin2c)
> -- 
> 2.0.0
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


