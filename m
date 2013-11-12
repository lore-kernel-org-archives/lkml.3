Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3KLOaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:30:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54892 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab3KLOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:30:32 -0500
Date: Tue, 12 Nov 2013 14:30:31 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
Message-ID: <20131112143031.GF6549@opensource.wolfsonmicro.com>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com> <52817321.9040505@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52817321.9040505@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 09:15:29AM +0900, Chanwoo Choi wrote:
> Hi CHarles,
> 
> On 11/08/2013 10:19 PM, Charles Keepax wrote:
> > As a small disclaimer I would personally prefer to not merge this patch.
> > I have added it based on previous code review of the other patches in
> > this chain.
> > 
> > arizona_hpdet_do_id currently can only return 0 or -EAGAIN making the
> > else if clause handling error codes redundant, this patch removes this
> > clause.
> > 
> > Whilst this clause is not currently hit removing it makes the code
> > fragile. It will not be obvious whilst editing arizona_hpdet_do_id that
> > you shouldn't add a return value other than 0 or -EAGAIN.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/extcon/extcon-arizona.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> > index 0d70bf6..2313b1e 100644
> > --- a/drivers/extcon/extcon-arizona.c
> > +++ b/drivers/extcon/extcon-arizona.c
> > @@ -476,6 +476,9 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
> >  	return val;
> >  }
> >  
> > +/* This function should only return 0 or -EAGAIN, if other return values are
> > + * added additional handling should be added in arizona_hpdet_irq.
> > + */
> 
> As Lee Jones commented, you should modify this comment of arizona_hpdet_do_id() and add
> the description of return value. Because arizoa_hpdet_do_id() has different meaning
> between -EAGAIN and other minus value.

I take it you are still very keen on applying a patch for this
dead code elimination? I really do feel it would be better to
leave this part of the code as it currently is, the extra safety
clearly outweights the cost of a redundant else if.

Thanks,
Charles
