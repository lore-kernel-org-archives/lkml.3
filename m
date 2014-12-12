Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaLLWqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:46:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaLLWqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:46:49 -0500
Message-ID: <548B70B3.7030807@oracle.com>
Date: Fri, 12 Dec 2014 17:48:19 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] xen: build infrastructure for generating hypercall
 depending symbols
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-2-git-send-email-jgross@suse.com>
In-Reply-To: <1418321065-10212-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 01:04 PM, Juergen Gross wrote:
> diff --git a/scripts/xen-hypercalls.sh b/scripts/xen-hypercalls.sh
> new file mode 100644
> index 0000000..e6447b7
> --- /dev/null
> +++ b/scripts/xen-hypercalls.sh
> @@ -0,0 +1,11 @@
> +#!/bin/sh
> +out="$1"
> +shift
> +in="$@"
> +
> +for i in $in; do
> +	eval $CPP $LINUXINCLUDE -dD -imacros "$i" -x c /dev/null
> +done | \
> +awk '$1 == "#define" && $2 ~ /__HYPERVISOR_[a-z][a-z_0-9]*/ { v[$3] = $2 }
> +	END {for (i in v) if (!(v[i] in v))
> +		print "HYPERCALL("substr(v[i], 14)")"}' | sort -u >$out

Why do you 'sort -u'? Do you expect multiple definitions of the same 
hypercall?

-boris
