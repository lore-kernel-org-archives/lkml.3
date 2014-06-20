Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967268AbaFTSoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:44:15 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:52063 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923AbaFTSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:44:14 -0400
Date: Fri, 20 Jun 2014 20:44:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Build List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] Makefile: Make HOSTCFLAGS and HOSTCXXFLAGS user
 modifyable
Message-ID: <20140620184407.GA21269@ravnborg.org>
References: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
 <1403289089-11299-2-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403289089-11299-2-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:31:28AM -0700, Markus Mayer wrote:
> In order to allow the user to pass extra arguments to the host
> compiler, we no longer overwrite the host compiler flags in the
> makefile, but append them to what was passed in.
> 
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 97b2861..5795eea 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -251,8 +251,8 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
>  
>  HOSTCC       = gcc
>  HOSTCXX      = g++
> -HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
> -HOSTCXXFLAGS = -O2
> +HOSTCFLAGS   += -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
> +HOSTCXXFLAGS += -O2
>  
>  ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
>  HOSTCFLAGS  += -Wno-unused-value -Wno-unused-parameter \

With this patch you can only override HOSTCFLAGS.
In many cases appending to the falgs is actually what you want.

Please take a look at how we have implemented it for the kernel with KCFLAGS.
And notice that this is also described in Documentation/kbuild

	Sam
