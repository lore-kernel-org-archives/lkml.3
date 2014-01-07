Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaAGTeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:34:18 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37135 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbaAGTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:34:05 -0500
Date: Tue, 7 Jan 2014 13:34:00 -0600
From: Ben Myers <bpm@sgi.com>
To: Jeff Liu <jeff.liu@oracle.com>, Chuansheng Liu <chuansheng.liu@intel.com>
Cc: dchinner@fromorbit.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
 INIT_WORK_ONSTACK()
Message-ID: <20140107193400.GC1935@sgi.com>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
 <1389084814.3650.70.camel@cliu38-desktop-build>
 <52CBE321.4050906@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CBE321.4050906@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 07:21:05PM +0800, Jeff Liu wrote:
> Hi Chuansheng,
> 
> On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> > 
> > In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> > call destroy_work_on_stack() which frees the debug object to pair
> > with INIT_WORK_ONSTACK().
> > 
> > Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 1394106..82e0dab 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -287,6 +287,7 @@ xfs_bmapi_allocate(
> >  	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
> >  	queue_work(xfs_alloc_wq, &args->work);
> >  	wait_for_completion(&done);
> > +	destroy_work_on_stack(&args->work);
> >  	return args->result;
> >  }
> 
> Thanks for your patch and it work fine for my testing.  I missed this in an
> old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ] 

Looks good to me too.
Reviewed-by: Ben Myers <bpm@sgi.com>
