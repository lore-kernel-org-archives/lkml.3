Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaD0Wjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:39:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaD0Wjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:39:33 -0400
Date: Sun, 27 Apr 2014 15:40:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>
Subject: Re: [PATCH 3/5] staging/lustre/lnet: fix potential null pointer
 dereference
Message-ID: <20140427224019.GD1563@kroah.com>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
 <1398633446-16719-4-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398633446-16719-4-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 05:17:24PM -0400, Oleg Drokin wrote:
> From: Dmitry Eremin <dmitry.eremin@intel.com>
> 
> Pointer 'tsc' returned from call to function 'sfw_find_test_case'
> at line 571 may be NULL and will be dereferenced at line 572.
> found by Klocwork Insight tool
> 
> Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
> Reviewed-on: http://review.whamcloud.com/9386
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Isaac Huang <he.huang@intel.com>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
> ---
>  drivers/staging/lustre/lnet/selftest/framework.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
> index 050723a..c141f93 100644
> --- a/drivers/staging/lustre/lnet/selftest/framework.c
> +++ b/drivers/staging/lustre/lnet/selftest/framework.c
> @@ -547,10 +547,16 @@ sfw_test_rpc_fini (srpc_client_rpc_t *rpc)
>  static inline int
>  sfw_test_buffers(sfw_test_instance_t *tsi)
>  {
> -	struct sfw_test_case	*tsc = sfw_find_test_case(tsi->tsi_service);
> -	struct srpc_service	*svc = tsc->tsc_srv_service;
> +	struct sfw_test_case	*tsc;
> +	struct srpc_service	*svc;
>  	int			nbuf;
>  
> +	LASSERT(tsi != NULL);

Asserts suck rocks, which is why we avoid them at all costs.  Please
just fix the code to work properly.  If that parameter can be NULL, then
properly handle the error and return, don't oops the kernel.

greg k-h
