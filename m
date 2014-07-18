Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343AbaGRXaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:30:23 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60043 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321AbaGRXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:30:18 -0400
Date: Sat, 19 Jul 2014 01:29:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
Message-ID: <20140718232958.GA22487@ravnborg.org>
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:44:34PM -0600, Shuah Khan wrote:
> Add a new devtest make target to enable developer testing. This
> new target does full build (make all) and then runs selftests.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  Makefile | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index f3c543d..1ef3128 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1034,6 +1034,14 @@ headers_check: headers_install
>  	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
>  
>  # ---------------------------------------------------------------------------
> +# Kernel devtest
> +
> +PHONY += devtest
> +devtest:
> +	make all
> +	make -C tools/testing/selftests run_tests

The name "devtest" does not give any hints that we are actually
running the suite of selftest programs.

Is it so because the plan is to extend devtest to cover more than just selftest?
If not please fix it so it is logical for the user what happens - in other
words name is selftest or something like that.

	Sam
