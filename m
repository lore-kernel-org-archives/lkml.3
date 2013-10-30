Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3J3UIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:08:16 -0400
Received: from sandeen.net ([63.231.237.45]:53690 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3J3UIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:08:15 -0400
Message-ID: <5271672C.7070101@sandeen.net>
Date: Wed, 30 Oct 2013 15:08:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ben Myers <bpm@sgi.com>,
        =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
CC: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard>	<5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com> <20131023203435.GR1935@sgi.com>
In-Reply-To: <20131023203435.GR1935@sgi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/13 3:34 PM, Ben Myers wrote:

> xfs: fix possible NULL dereference in xlog_verify_iclog
> 
> In xlog_verify_iclog a debug check of the incore log buffers prints an
> error if icptr is null and then goes on to dereference the pointer
> regardless.  Convert this to an assert so that the intention is clear.
> This was reported by Coverty.
> 
> Reported-by: Geyslan G. Bem <geyslan@gmail.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_log.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> Index: b/fs/xfs/xfs_log.c
> ===================================================================
> --- a/fs/xfs/xfs_log.c	2013-10-23 14:52:47.875216875 -0500
> +++ b/fs/xfs/xfs_log.c	2013-10-23 14:53:53.775245830 -0500
> @@ -3714,11 +3714,9 @@ xlog_verify_iclog(
>  	/* check validity of iclog pointers */
>  	spin_lock(&log->l_icloglock);
>  	icptr = log->l_iclog;
> -	for (i=0; i < log->l_iclog_bufs; i++) {
> -		if (icptr == NULL)
> -			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> -		icptr = icptr->ic_next;
> -	}
> +	for (i=0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
> +      		ASSERT(icptr);
> +
>  	if (icptr != log->l_iclog)
>  		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
>  	spin_unlock(&log->l_icloglock);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

