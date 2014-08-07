Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaHGUSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:18:44 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:44205 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:18:41 -0400
Date: Thu, 7 Aug 2014 22:18:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kbuild: kselftest - new make target to build and run
 kernel selftests
Message-ID: <20140807201835.GA2503@ravnborg.org>
References: <1407438466-7196-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407438466-7196-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 01:07:46PM -0600, Shuah Khan wrote:
> Add a new make target "kselftest" to enable kernel testing. This
> new target builds and runs kernel selftests. Running as root is
> recommended for a complete test run as some tests don't run when
> run by non-root user. Build, install, and boot kernel before
> running kselftest on it.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  Makefile | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index d0901b4..574e8da 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1036,6 +1036,13 @@ headers_check: headers_install
>  	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
>  
>  # ---------------------------------------------------------------------------
> +# Kernel selftest
> +
> +PHONY += kselftest
> +kselftest:
> +	$(Q)$(MAKE) -C tools/testing/selftests run_tests
> +
> +# ---------------------------------------------------------------------------
>  # Modules
>  
>  ifdef CONFIG_MODULES
> @@ -1238,6 +1245,11 @@ help:
>  	@echo  '  headerdep       - Detect inclusion cycles in headers'
>  	@$(MAKE) -f $(srctree)/scripts/Makefile.help checker-help
>  	@echo  ''
> +	@echo  'Kernel selftest'
> +	@echo  '  kselftest       - Build and run kernel selftest (run as root)'
> +	@echo  '                    Build, install, and boot kernel before'
> +	@echo  '                    running kselftest on it'
It is never good to advertise to run something as root.
But I see that this is recommended for now so the patch has my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

