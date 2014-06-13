Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaFMJpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:45:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbaFMJpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:45:17 -0400
Message-ID: <539AC82B.4070505@suse.cz>
Date: Fri, 13 Jun 2014 11:45:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not run modules_install and install in paralel
References: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com> <1402652395-28779-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1402652395-28779-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.6.2014 11:39, Michal Marek napsal(a):
> Based on a x86-only patch by Andy Lutomirski <luto@amacapital.net>
> 
> With modular kernels, 'make install' is going to need the installed
> modules at some point to generate the initramfs.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 7680d7c..7e5e483 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -503,6 +503,12 @@ ifeq ($(KBUILD_EXTMOD),)
>                  endif
>          endif
>  endif
> +# install and module_install need also be processed one by one
> +ifneq ($(filter install,$(MAKECMDGOALS)),)
> +        ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
> +	        mixed-targets := 1
> +        endif
> +endif

Note that this version does not enforce the ordering, it just avoids the
interleaved execution. It can be added if desired.

Michal
