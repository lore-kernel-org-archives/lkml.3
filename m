Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaHYTL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaHYTL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:11:27 -0400
Date: Mon, 25 Aug 2014 15:11:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Welling <mwelling@ieee.org>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] purgatory: add clean-up for purgatory directory
Message-ID: <20140825191113.GI14379@redhat.com>
References: <1408750630-11573-1-git-send-email-mwelling@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408750630-11573-1-git-send-email-mwelling@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:37:10PM -0500, Michael Welling wrote:
> Without this patch the kexec-purgatory.c and purgatory.ro files are not removed after make mrproper.
> 
> Signed-off-by: Michael Welling <mwelling@ieee.org>

Looks good to me. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  arch/x86/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index c96bcec..60087ca 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -251,6 +251,7 @@ archclean:
>  	$(Q)rm -rf $(objtree)/arch/x86_64
>  	$(Q)$(MAKE) $(clean)=$(boot)
>  	$(Q)$(MAKE) $(clean)=arch/x86/tools
> +	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
>  
>  PHONY += kvmconfig
>  kvmconfig:
> -- 
> 1.7.9.5
