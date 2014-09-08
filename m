Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaIHWWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:22:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24297 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaIHWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:22:11 -0400
Date: Tue, 9 Sep 2014 01:21:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hugues <morisset.hugues@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: lustre: fix coding style issues
Message-ID: <20140908222155.GM6600@mwanda>
References: <540E27FB.2070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540E27FB.2070206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix your email "From" header to say your full name instead of just
From: Hugues <morisset.hugues@gmail.com>

All the subjects are the same so redo these patches.  Also don't pick
the most vague subject you can think of.  Mention "long lines", for
example.

On Tue, Sep 09, 2014 at 12:04:43AM +0200, Hugues wrote:
> Fix coding style issues:
> * limit the length of changed lines to 80 columns.

Send the patch inline and not as an attachment.

Most of these changes are improvements, but I have some additional
comments inline.

> --- a/drivers/staging/lustre/lustre/include/obd.h
> +++ b/drivers/staging/lustre/lustre/include/obd.h
> @@ -101,7 +101,8 @@ struct lov_stripe_md {
>  		__u32 lw_magic;
>  		__u32 lw_stripe_size;      /* size of the stripe */
>  		__u32 lw_pattern;	  /* striping pattern (RAID0, RAID1) */
> -		__u16 lw_stripe_count;  /* number of objects being striped over */
> +		__u16 lw_stripe_count;
> +			/* number of objects being striped over */

The comment goes on the line before the data so now it looks like it
goes with lw_layout_gen.

>  		__u16 lw_layout_gen;       /* generation of the layout */
>  		char  lw_pool_name[LOV_MAXPOOLNAME]; /* pool name */
> @@ -639,7 +640,8 @@ struct niobuf_local {
>  #define LUSTRE_LWP_NAME		"lwp"
>  
>  /* obd device type names */
> - /* FIXME all the references to LUSTRE_MDS_NAME should be swapped with LUSTRE_MDT_NAME */
> + /* FIXME all the references to LUSTRE_MDS_NAME
> +    should be swapped with LUSTRE_MDT_NAME */

This comment is not in kernel style.  Read Documentation/CodingStyle

> @@ -733,6 +735,7 @@ static inline void oti_init(struct obd_trans_info *oti,
>  	if (req->rq_reqmsg != NULL &&
>  	    lustre_msg_get_flags(req->rq_reqmsg) & MSG_REPLAY) {
>  		__u64 *pre_version = lustre_msg_get_versions(req->rq_reqmsg);
> +
>  		oti->oti_pre_version = pre_version ? pre_version[0] : 0;

This is unrelated to long lines.

>  		oti->oti_transno = lustre_msg_get_transno(req->rq_reqmsg);
>  	}
> @@ -847,14 +850,15 @@ struct obd_device {
>  		      obd_recovering:1,    /* there are recoverable clients */
>  		      obd_abort_recovery:1,/* recovery expired */
>  		      obd_version_recov:1, /* obd uses version checking */
> -		      obd_replayable:1,    /* recovery is enabled; inform clients */
> -		      obd_no_transno:1,    /* no committed-transno notification */
> +		      obd_replayable:1,    /* recovery is enabled;
> +					      inform clients */
> +		      obd_no_transno:1,	/* no committed-transno notification */

Sometimes the code looks better if you just go past the 80 character
limit.  The columns line up nicer.  Remember, checkpatch.pl serves you;
you are not the servant to it.

> @@ -909,9 +913,9 @@ struct obd_device {
>  	int			      obd_requests_queued_for_recovery;
>  	wait_queue_head_t		      obd_next_transno_waitq;
>  	/* protected by obd_recovery_task_lock */
> -	struct timer_list	      obd_recovery_timer;
> -	time_t			   obd_recovery_start; /* seconds */
> -	time_t			   obd_recovery_end; /* seconds, for lprocfs_status */
> +	struct timer_list	obd_recovery_timer;
> +	time_t			obd_recovery_start; /* seconds */
> +	time_t		obd_recovery_end; /* seconds, for lprocfs_status */

Random alignment.

regards,
dan carpenter


