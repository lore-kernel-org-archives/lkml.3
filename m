Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaBTMqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:46:03 -0500
Received: from multi.imgtec.com ([194.200.65.239]:39501 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaBTMqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:46:01 -0500
Message-ID: <5305F928.5070600@imgtec.com>
Date: Thu, 20 Feb 2014 12:46:32 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Michal Marek <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        "Markos Chandras" <Markos.Chandras@imgtec.com>
Subject: Re: [PATCH] Makefile: Unset stack-protector gcc flag if it is not
 supported
References: <1391793327-9578-1-git-send-email-markos.chandras@imgtec.com>
In-Reply-To: <1391793327-9578-1-git-send-email-markos.chandras@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.47]
X-SEF-Processed: 7_3_0_01192__2014_02_20_12_45_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 05:15 PM, Markos Chandras wrote:
> In case the compiler does not support the stack-protector option,
> unset the flag to avoid build failures. Printing a warning is enough
> to let the user know that this flag will not be used.
> Fixes the following build problem when using a toolchain which does
> not support the -fstack-protector-strong flag:
>
> Makefile:614: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG:
> -fstack-protector-strong not supported by compiler
> mips-linux-gnu-gcc: error: unrecognized command line option
> '-fstack-protector-strong'
> scripts/Makefile.build:308: recipe for target 'scripts/mod/empty.o' failed
> make[2]: *** [scripts/mod/empty.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> scripts/Makefile.build:455: recipe for target 'scripts/mod' failed
>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> ---
>   Makefile | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 606ef7c..63a5333 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -607,12 +607,14 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>     ifeq ($(call cc-option, $(stackp-flag)),)
>       $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
>   	      -fstack-protector not supported by compiler))
> +    stackp-flag :=
>     endif
>   else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>     stackp-flag := -fstack-protector-strong
>     ifeq ($(call cc-option, $(stackp-flag)),)
>       $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
>   	      -fstack-protector-strong not supported by compiler)
> +    stackp-flag :=
>     endif
>   else
>     # Force off for distro compilers that enable stack protector by default.
>

Ping again?

-- 
markos

