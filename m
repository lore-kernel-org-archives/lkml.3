Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaK0Afk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:35:40 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41108 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaK0Afj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:35:39 -0500
Date: Thu, 27 Nov 2014 00:35:23 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, eunb.song@samsung.com, gulsah.1004@gmail.com,
        paul.gortmaker@windriver.com, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: octeon: Fix checkpatch warning
Message-ID: <20141127003523.GA3249@biggie>
References: <20141125132614.GA23857@biggie>
 <20141126214523.GA10037@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126214523.GA10037@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:45:23PM -0800, Greg KH wrote:
> On Tue, Nov 25, 2014 at 01:26:14PM +0000, Luis de Bethencourt wrote:
> > This patch fixes the checkpatch.pl warnings:
> > 
> > WARNING: line over 80 characters
> > +                       int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
> > 
> > WARNING: line over 80 characters
> > +                       skb->data = skb->head + work->packet_ptr.s.addr - cvmx_ptr_to_phys(skb->head);
> > 
> > Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> > ---
> >  drivers/staging/octeon/ethernet-rx.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> > index 44e372f..bd83f55 100644
> > --- a/drivers/staging/octeon/ethernet-rx.c
> > +++ b/drivers/staging/octeon/ethernet-rx.c
> > @@ -295,7 +295,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
> >  			 */
> >  			union cvmx_pow_wq_int_cntx counts;
> >  			int backlog;
> > -			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
> > +			int cores_in_use = core_state.baseline_cores -
> > +				atomic_read(&core_state.available_cores);
> >  			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
> >  			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
> >  			if (backlog > budget * cores_in_use && napi != NULL)
> > @@ -324,7 +325,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
> >  		 * buffer.
> >  		 */
> >  		if (likely(skb_in_hw)) {
> > -			skb->data = skb->head + work->packet_ptr.s.addr - cvmx_ptr_to_phys(skb->head);
> > +			skb->data = skb->head + work->packet_ptr.s.addr -
> > +				cvmx_ptr_to_phys(skb->head);
> >  			prefetch(skb->data);
> >  			skb->len = work->len;
> >  			skb_set_tail_pointer(skb, skb->len);
> > -- 
> > 2.1.3
> 
> No longer applies to my tree :(

I'm confused.

I just tried applying it to what I think is your tree is and it worked.
https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/?h=staging-next

Do I have this wrong?

Sorry :(
