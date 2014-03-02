Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaCBJEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:04:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:39000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaCBJEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:04:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,571,1389772800"; 
   d="scan'208";a="490752803"
Message-ID: <5312F3FF.80700@linux.intel.com>
Date: Sun, 02 Mar 2014 17:03:59 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: shuox.liu@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
In-Reply-To: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 14:37, shuox.liu@intel.com wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> ftrace_read_cnt need to be reset in open to support mutli times
> getting the records.

Andrew,

Would you like to merge it to your testing tree?
pstore is a very important feature for debugging hard issues on
Android mobiles.

Yanmin

>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>   fs/pstore/ram.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index fa8cef2..a5d0cab 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>   
>   	cxt->dump_read_cnt = 0;
>   	cxt->console_read_cnt = 0;
> +	cxt->ftrace_read_cnt = 0;
>   	return 0;
>   }
>   

