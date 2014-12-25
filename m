Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaLYWlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:41:22 -0500
Received: from plane.gmane.org ([80.91.229.3]:33483 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaLYWlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:41:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 2/6] kbuild: do not add $(call ...) to invoke cc-version
 or cc-fullversion
Date: Thu, 25 Dec 2014 23:41:02 +0100
Message-ID: <549C927E.7090706@gmx.de>
References: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com> <1419485488-22336-3-git-send-email-yamada.m@jp.panasonic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-parisc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-doc@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: linux-parisc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-Gmane-NNTP-Posting-Host: p54ad0d61.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <1419485488-22336-3-git-send-email-yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2014 06:31 AM, Masahiro Yamada wrote:
> The macros cc-version, cc-fullversion and ld-version take no argument.
> It is not necessary to add $(call ...) to invoke them.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
>
>   Documentation/kbuild/makefiles.txt | 4 ++--
>   arch/parisc/Makefile               | 2 +-

For the parisc change:
Acked-by: Helge Deller <deller@gmx.de>


Helge

>   arch/powerpc/Makefile              | 6 +++---
>   arch/x86/Makefile.um               | 2 +-
>   kernel/gcov/Makefile               | 2 +-
>   scripts/Kbuild.include             | 7 ++-----
>   6 files changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index a311db8..7b3487a 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -524,7 +524,7 @@ more details, with real examples.
>   	Example:
>   		#arch/x86/Makefile
>   		cflags-y += $(shell \
> -		if [ $(call cc-version) -ge 0300 ] ; then \
> +		if [ $(cc-version) -ge 0300 ] ; then \
>   			echo "-mregparm=3"; fi ;)
>
>   	In the above example, -mregparm=3 is only used for gcc version greater
> @@ -552,7 +552,7 @@ more details, with real examples.
>
>   	Example:
>   		#arch/powerpc/Makefile
> -		$(Q)if test "$(call cc-fullversion)" = "040200" ; then \
> +		$(Q)if test "$(cc-fullversion)" = "040200" ; then \
>   			echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
>   			false ; \
>   		fi
> diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
> index e9b4b6a..ff5e55f 100644
> --- a/arch/parisc/Makefile
> +++ b/arch/parisc/Makefile
> @@ -149,7 +149,7 @@ endef
>   # we require gcc 3.3 or above to compile the kernel
>   archprepare: checkbin
>   checkbin:
> -	@if test "$(call cc-version)" -lt "0303"; then \
> +	@if test "$(cc-version)" -lt "0303"; then \
>   		echo -n "Sorry, GCC v3.3 or above is required to build " ; \
>   		echo "the kernel." ; \
>   		false ; \
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 132d9c6..fc502e0 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -314,7 +314,7 @@ TOUT	:= .tmp_gas_check
>   # - Require gcc 4.0 or above on 64-bit
>   # - gcc-4.2.0 has issues compiling modules on 64-bit
>   checkbin:
> -	@if test "$(call cc-version)" = "0304" ; then \
> +	@if test "$(cc-version)" = "0304" ; then \
>   		if ! /bin/echo mftb 5 | $(AS) -v -mppc -many -o $(TOUT) >/dev/null 2>&1 ; then \
>   			echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build '; \
>   			echo 'correctly with gcc-3.4 and your version of binutils.'; \
> @@ -322,13 +322,13 @@ checkbin:
>   			false; \
>   		fi ; \
>   	fi
> -	@if test "$(call cc-version)" -lt "0400" \
> +	@if test "$(cc-version)" -lt "0400" \
>   	    && test "x${CONFIG_PPC64}" = "xy" ; then \
>                   echo -n "Sorry, GCC v4.0 or above is required to build " ; \
>                   echo "the 64-bit powerpc kernel." ; \
>                   false ; \
>           fi
> -	@if test "$(call cc-fullversion)" = "040200" \
> +	@if test "$(cc-fullversion)" = "040200" \
>   	    && test "x${CONFIG_MODULES}${CONFIG_PPC64}" = "xyy" ; then \
>   		echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
>   		echo 'kernel with modules enabled.' ; \
> diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
> index 36b62bc..95eba55 100644
> --- a/arch/x86/Makefile.um
> +++ b/arch/x86/Makefile.um
> @@ -30,7 +30,7 @@ cflags-y += -ffreestanding
>   # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
>   # a lot more stack due to the lack of sharing of stacklots.  Also, gcc
>   # 4.3.0 needs -funit-at-a-time for extern inline functions.
> -KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
> +KBUILD_CFLAGS += $(shell if [ $(cc-version) -lt 0400 ] ; then \
>   			echo $(call cc-option,-fno-unit-at-a-time); \
>   			else echo $(call cc-option,-funit-at-a-time); fi ;)
>
> diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
> index 52aa7e8..6f01fa3 100644
> --- a/kernel/gcov/Makefile
> +++ b/kernel/gcov/Makefile
> @@ -21,7 +21,7 @@ else
>   # is not available. We can probably move if-lt to Kbuild.include, so it's also
>   # not defined during clean or to include Kbuild.include in
>   # scripts/Makefile.clean. But the following workaround seems least invasive.
> -  cc-ver := $(if $(call cc-version),$(call cc-version),0)
> +  cc-ver := $(if $(cc-version),$(cc-version),0)
>   endif
>
>   obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index a972666..69c9f57 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -136,17 +136,15 @@ cc-disable-warning = $(call try-run,\
>   	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
>
>   # cc-version
> -# Usage gcc-ver := $(call cc-version)
>   cc-version = $(shell $(KBUILD_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))
>
>   # cc-fullversion
> -# Usage gcc-ver := $(call cc-fullversion)
>   cc-fullversion = $(shell $(KBUILD_SHELL) \
>   	$(srctree)/scripts/gcc-version.sh -p $(CC))
>
>   # cc-ifversion
>   # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
> -cc-ifversion = $(shell [ $(call cc-version) $(1) $(2) ] && echo $(3))
> +cc-ifversion = $(shell [ $(cc-version) $(1) $(2) ] && echo $(3))
>
>   # cc-ldoption
>   # Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
> @@ -164,13 +162,12 @@ ld-option = $(call try-run,\
>   ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
>
>   # ld-version
> -# Usage: $(call ld-version)
>   # Note this is mainly for HJ Lu's 3 number binutil versions
>   ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
>
>   # ld-ifversion
>   # Usage:  $(call ld-ifversion, -ge, 22252, y)
> -ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
> +ld-ifversion = $(shell [ $(ld-version) $(1) $(2) ] && echo $(3))
>
>   ######
>
>


