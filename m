Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161830Ab3DEP07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:26:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:56068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762185Ab3DEP06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:26:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="289941745"
Message-ID: <515EED40.9000102@linux.intel.com>
Date: Fri, 05 Apr 2013 08:26:56 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Bruce Ashfield <bruce.ashfield@windriver.com>
Subject: Re: [PATCH] merge_config.sh: Avoid creating unnessary source softlinks
References: <1365102179-19176-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1365102179-19176-1-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/04/2013 12:02 PM, John Stultz wrote:
> Viresh noticed when using merge_config.sh that a source softlink
> was being created even when he didn't specify the -O option.
> 
> The problem arises due to the previous commit 409f117e2d6b
> which added the -O option. Basically if -O is not specified,
> we still pass '-O=.' to the make command, which then generates
> a source softlink to ./
> 
> This patch adds an extra check so if there is no -O specified
> to merge_config.sh, we don't pass one on to make.
> 
> Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Bruce Ashfield <bruce.ashfield@windriver.com>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thanks John!

Acked-by: Darren Hart <dvhart@linux.intel.com>


> ---
>  scripts/kconfig/merge_config.sh |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> index 05274fc..81b0c61 100755
> --- a/scripts/kconfig/merge_config.sh
> +++ b/scripts/kconfig/merge_config.sh
> @@ -120,10 +120,18 @@ if [ "$MAKE" = "false" ]; then
>  	exit
>  fi
>  
> +# If we have an output dir, setup the O= argument, otherwise leave
> +# it blank, since O=. will create an unnecessary ./source softlink
> +OUTPUT_ARG=""
> +if [ "$OUTPUT" != "." ] ; then
> +	OUTPUT_ARG="O=$OUTPUT"
> +fi
> +
> +
>  # Use the merged file as the starting point for:
>  # alldefconfig: Fills in any missing symbols with Kconfig default
>  # allnoconfig: Fills in any missing symbols with # CONFIG_* is not set
> -make KCONFIG_ALLCONFIG=$TMP_FILE O=$OUTPUT $ALLTARGET
> +make KCONFIG_ALLCONFIG=$TMP_FILE $OUTPUT_ARG $ALLTARGET
>  
>  
>  # Check all specified config values took (might have missed-dependency issues)
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
