Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbaFQVO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:14:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:13199 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907AbaFQVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,496,1400050800"; 
   d="scan'208";a="559107427"
Date: Tue, 17 Jun 2014 14:14:55 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 2/2] tmon: set umask to a reasonable value
Message-ID: <20140617141455.6d756370@ultegra>
In-Reply-To: <1403035509-31815-3-git-send-email-nhorman@tuxdriver.com>
References: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
	<1403035509-31815-3-git-send-email-nhorman@tuxdriver.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 16:05:09 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> current, the tmon umask value is set to 0, which mean whatever the
Currently, ..., which means ...
> permission mask in the shell are when starting tmon in daemon mode
> are what the permissions of any created files will be.  We should
> likely set something more explicit, so lets go with the usual 022
> 
Just some grammar suggestion. Otherwise,
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Zhang Rui <rui.zhang@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  tools/thermal/tmon/tmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
> index 059e0be..09b7c32 100644
> --- a/tools/thermal/tmon/tmon.c
> +++ b/tools/thermal/tmon/tmon.c
> @@ -355,7 +355,7 @@ static void start_daemon_mode()
>  	disable_tui();
>  
>  	/* change the file mode mask */
> -	umask(0);
> +	umask(S_IWGRP | S_IWOTH);
>  
>  	/* new SID for the daemon process */
>  	sid = setsid();

[Jacob Pan]

-- 
Thanks,

Jacob
