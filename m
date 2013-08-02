Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3HBWtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:49:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34378 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3HBWtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:49:19 -0400
Message-ID: <51FC3769.2030302@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 15:49:13 -0700
From: Zach Levis <zml@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.3
MIME-Version: 1.0
To: Zach Levis <zml@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH v2 2/3] fs/binfmts: Better handling of binfmt loops
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1375481535-20034-3-git-send-email-zml@linux.vnet.ibm.com>
In-Reply-To: <1375481535-20034-3-git-send-email-zml@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080222-0320-0000-0000-00000088C7FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:12 PM, Zach Levis wrote:

> +		if (retval == -ELOOP && bprm->recursion_depth == 0) { /* cur, previous */
> +			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> +					bprm->previous_binfmts[0]->name,
> +					bprm->previous_binfmts[1]->name,
> +					bprm->filename,
> +					fmt->name);
> +
> +			/* Put argv back in its place */
> +			bprm->p = bprm->p_no_argv;
> +
> +			bprm->argc = count(*(bprm->argv_orig), MAX_ARG_STRINGS);
> +			retval = copy_strings(bprm->argc, *(bprm->argv_orig), bprm);
> +			if (retval < 0)
> +				return retval;
> +
> +			retval = -ENOEXEC;
> +			continue;
> +		}
>   	}
>   	read_unlock(&binfmt_lock);
>

NEVERMIND, I messed up the order here so this doesn't work! v3 coming up 
without the stupid.

