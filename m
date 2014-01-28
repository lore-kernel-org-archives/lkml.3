Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaA1Dqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:46:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaA1Dqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:46:43 -0500
Date: Mon, 27 Jan 2014 22:46:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [V0 PATCH] pvh: Disable PSE feature for now
Message-ID: <20140128034634.GC20680@pegasus.dumpdata.com>
References: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
 <1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 06:18:39PM -0800, Mukesh Rathor wrote:
> Until now, xen did not expose PSE to pvh guest, but a patch was submitted
> to xen list to enable bunch of features for a pvh guest. PSE has not been

Which 'patch'?

> looked into for PVH, so until we can do that and test it to make sure it
> works, disable the feature to avoid flood of bugs.

I think we want a flood of bugs, no?
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index a4d7b64..4e952046 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1497,6 +1497,11 @@ static void __init xen_pvh_early_guest_init(void)
>  	xen_have_vector_callback = 1;
>  	xen_pvh_set_cr_flags(0);
>  
> +        /* pvh guests are not quite ready for large pages yet */
> +        setup_clear_cpu_cap(X86_FEATURE_PSE);
> +        setup_clear_cpu_cap(X86_FEATURE_PSE36);
> +
> +
>  #ifdef CONFIG_X86_32
>  	BUG(); /* PVH: Implement proper support. */
>  #endif
> -- 
> 1.7.2.3
> 
