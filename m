Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3C1SOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:14:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:35899 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3C1SOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:14:04 -0400
Message-ID: <51547A4E.4010600@infradead.org>
Date: Thu, 28 Mar 2013 10:13:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: allow no update .config build
References: <1364455686-18930-1-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1364455686-18930-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/13 00:28, liguang wrote:
> if we pull some commits from other git repo
> which bring in a few CONFIG_* options, then
> we have to build all again, but we do assure
> these options are not interesting for us,
> so the long waiting build will be offending.
> this change help us to avoid all-build.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  Makefile |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 54d2b2a..d10e505 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -106,6 +106,12 @@ ifeq ("$(origin W)", "command line")
>    export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
>  endif
>  
> +# KBUILD_NCU is set to do not update .config even
> +# a few new CONFIG_* options appeared
> +ifeq ("$(origin NCU)", "command line")
> +  KBUILD_NCU := $(NCU)
> +endif
> +
>  # That's our default target when none is given on the command line
>  PHONY := _all
>  _all:
> @@ -540,8 +546,10 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
>  # with it and forgot to run make oldconfig.
>  # if auto.conf.cmd is missing then we are probably in a cleaned tree so
>  # we execute the config step to be sure to catch updated Kconfig files
> +ifneq ($(KBUILD_NCU), 1)
>  include/config/%.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
>  	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
> +endif # $(KBUILD_NCU)
>  else
>  # external modules needs include/generated/autoconf.h and include/config/auto.conf
>  # but do not care if they are up-to-date. Use auto.conf to trigger the test
> @@ -1157,6 +1165,7 @@ help:
>  	@echo  '		2: warnings which occur quite often but may still be relevant'
>  	@echo  '		3: more obscure warnings, can most likely be ignored'
>  	@echo  '		Multiple levels can be combined with W=12 or W=123'
> +	@echo  '  make NCU=1 [targets] no .config udate'

	                                          update

>  	@echo  ''
>  	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
>  	@echo  'For further info see the ./README file'
> 


-- 
~Randy
