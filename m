Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaFLIdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:33:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbaFLIdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:33:52 -0400
Message-ID: <539965EE.6050001@suse.cz>
Date: Thu, 12 Jun 2014 10:33:50 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,build: Fix make -jN modules_install install
References: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
In-Reply-To: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 11.6.2014 21:41, Andy Lutomirski napsal(a):
> Every few months, I forget why I type:
> 
> $ sudo make -j12 modules_install && sudo make -j12 install
> 
> instead of just:
> 
> $ sudo make -j12 modules_install install
> 
> I try the latter, it appears to work, and then my machine won't boot
> because dracut got confused.  This fixes it once and for all: if you
> ask make to install modules and a kernel, you almost certainly want
> the modules installed *first* so that your initramfs scripts can
> find the modules.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/Makefile | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 33f71b0..7280d28 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -240,6 +240,15 @@ PHONY += install
>  install:
>  	$(Q)$(MAKE) $(build)=$(boot) $@
>  
> +# If installing modules and a kernel, it's very likely that some initramfs
> +# script associated with installing the kernel will reference the modules,
> +# so make sure that modules are installed first.
> +ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
> +  ifneq ($(filter modules_install,$(MAKECMDGOALS)),)

The two conditions are identical. Did you mean to check for "install" in
one of them?

Thanks,
Michal
