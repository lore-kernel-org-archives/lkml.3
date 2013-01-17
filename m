Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3AQUCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:02:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44293 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab3AQUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:02:09 -0500
X-Sasl-enc: BCTXO29/IF/UqnZJ6asxtYcvp9LYpiWTmrmQyydyd7UQ 1358452923
Date: Thu, 17 Jan 2013 12:02:02 -0800
From: "greg@kroah.com" <greg@kroah.com>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swetland@google.com" <swetland@google.com>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: Subject: [PATCH] [lmk]  improve ANR produce rate caused by high
 io wait on android,create a thread for lowmem killer instead of usingkswapd
Message-ID: <20130117200202.GA18131@kroah.com>
References: <EE928378561BF1449699C96571234A740FF11D0A@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE928378561BF1449699C96571234A740FF11D0A@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 05:51:47PM +0000, Tu, Xiaobing wrote:
> Resend to fix the typo issue.
> 
> 
> Subject: [PATCH] [lmk] create a thread for low mem killer instead of using kswapd
> 
> Currently low mem killer is registered as a shrinker and will be
> invoked by kswapd. Since low mem killer and kswapd has different
> criteria to invoke to work -- kswap wakes up when watermark of some
> certain order in zone is low, and low mem killer should do its job
> when free memory is below the min free threshold. In the case that
> the kswapd isn't waked up and lmk is, the killed process selected
> by lmk will release memory so that the kswapd doesn't need towork
> any more.So it is not appropriate to mix them together. A 20 minutes
> average vmstat shows that the iowait/page fault has huge improvement.
> In this way, it can reduce the chance of ANR due to high iowait.
> 
> orignal:
> flt    wa
> 62.70 2.00
> 
> with patch
> flt    wa
> 2.32  0.01
> 
> Signed-off-by: Zhang Di <di.zhang@intel.com>
> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |   87 +++++++++++++++++++++++++++--
>  mm/page_alloc.c                           |    7 ++-
>  mm/vmscan.c                               |    2 +
>  3 files changed, 89 insertions(+), 7 deletions(-)

This patch breaks the build if the android code is not selected, please
fix this up and resend if you really need this.

thanks,

greg k-h
