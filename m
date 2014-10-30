Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbaJ3PGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:06:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:6316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760228AbaJ3PGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,286,1413270000"; 
   d="scan'208";a="628356409"
Date: Thu, 30 Oct 2014 23:05:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kaslr: Prevent .bss from overlaping initrd
Message-ID: <20141030150541.GA17461@wfg-t540p.sh.intel.com>
References: <1414672901-29118-1-git-send-email-eternal.n08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414672901-29118-1-git-send-email-eternal.n08@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Junjie,

I got one error with this script:

awk: arch/x86/tools/calc_reserved.awk: line 23: function strtonum never defined

Have you tried both gawk/mawk?

Thanks,
Fengguang

> diff --git a/arch/x86/tools/calc_reserved.awk b/arch/x86/tools/calc_reserved.awk
> new file mode 100644
> index 000000000000..2ca69682338a
> --- /dev/null
> +++ b/arch/x86/tools/calc_reserved.awk
> @@ -0,0 +1,21 @@
> +#!/bin/awk -f
> +#
> +# Calculate the amount of space that we have to reserve for .bss and .brk
> +# sections
> +#
> +# Usage:
> +# objdump -h a.out | awk -f calc_reserved.awk
> +
> +BEGIN {
> +	sections = "^.bss$|^.brk$"
> +	size = 0;
> +}
> +
> +/^ *[0-9]+ [a-z._]+ *[0-9a-f]+/ {
> +	if (match($2, sections))
> +		size += strtonum("0x" $3);
> +}
> +
> +END {
> +	printf("%d\n", size);
> +}
> --
> 1.9.3
