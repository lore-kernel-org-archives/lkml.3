Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaH3S4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:56:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaH3S4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:56:20 -0400
Date: Sat, 30 Aug 2014 11:56:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hema Prathaban <hemaklnce@gmail.com>
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lustre: ptlrpc: Fix space required
Message-ID: <20140830185620.GA7455@kroah.com>
References: <20140821132907.GA4118@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821132907.GA4118@hema-Inspiron-3520>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 06:59:07PM +0530, Hema Prathaban wrote:
> This patch fixes the checkpatch.pl issue
> Error: Required space after " '+' ',' '=' '(' ' if' "
> 
> Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
> ---
>  drivers/staging/lustre/lustre/ptlrpc/client.c       |  2 +-
>  drivers/staging/lustre/lustre/ptlrpc/events.c       |  4 ++--
>  drivers/staging/lustre/lustre/ptlrpc/import.c       |  8 ++++----
>  drivers/staging/lustre/lustre/ptlrpc/llog_client.c  | 16 ++++++++--------
>  drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c |  6 +++---
>  drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c     |  2 +-
>  drivers/staging/lustre/lustre/ptlrpc/sec_config.c   |  6 +++---
>  drivers/staging/lustre/lustre/ptlrpc/sec_null.c     |  2 +-
>  drivers/staging/lustre/lustre/ptlrpc/service.c      |  2 +-
>  9 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
> index 8fa9b71..a327d19 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/client.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
> @@ -289,7 +289,7 @@ static void ptlrpc_at_adj_net_latency(struct ptlrpc_request *req,
>  	at = &req->rq_import->imp_at;
>  
>  	/* Network latency is total time less server processing time */
> -	nl = max_t(int, now - req->rq_sent - service_time, 0) +1/*st rounding*/;
> +	nl = max_t(int, now - req->rq_sent - service_time, 0) + 1/*st rounding*/;
>  	if (service_time > now - req->rq_sent + 3 /* bz16408 */)
>  		CWARN("Reported service time %u > total measured time "
>  		      CFS_DURATION_T"\n", service_time,
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
> index c3ec21d..9f5af45 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/events.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
> @@ -186,7 +186,7 @@ void client_bulk_callback(lnet_event_t *ev)
>  	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB, CFS_FAIL_ONCE))
>  		ev->status = -EIO;
>  
> -	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,CFS_FAIL_ONCE))
> +	if (CFS_FAIL_CHECK_ORSEuT(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2, CFS_FAIL_ONCE))

You obviously did not compile this code as it breaks the build :(

Please _always_ test build your patches, don't force others to find
errors like this, it's a huge waste of time on my end when it happens...

greg k-h
