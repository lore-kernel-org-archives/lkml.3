Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbbAPMCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:02:08 -0500
Received: from hofr.at ([212.69.189.236]:49789 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbbAPMCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:02:06 -0500
Date: Fri, 16 Jan 2015 13:02:03 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@infradead.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ib_srpt: wait_for_completion_timeout does not return
	negativ status
Message-ID: <20150116120203.GA26292@opentech.at>
References: <1421407217-9105-1-git-send-email-der.herr@hofr.at> <54B8FCAE.2020408@sandisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B8FCAE.2020408@sandisk.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Bart Van Assche wrote:

> On 01/16/15 12:20, Nicholas Mc Guire wrote:
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > ---
> > 
> > Patch is against 3.19.0-rc3 -next-20150109
> > 
> > Patch was compiletested only with x86_64_defconfig +
> > CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m
> > 
> >  drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index eb694dd..4e58c76 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
> >  	spin_unlock_irq(&sdev->spinlock);
> >  
> >  	res = wait_for_completion_timeout(&release_done, 60 * HZ);
> > -	WARN_ON(res <= 0);
> > +	WARN_ON(res == 0);
> >  }
> >  
> >  /**
> 
> The description of this patch explains why you would like to change this
> code but not why this change is useful. Does building the current code
> e.g. trigger a compiler warning ? If so, which warning ? If not, why
> would you like to change this code and why do you think this change is
> an improvement ?
>
the code will not fail in its urrent form but it will trigger 
static code chekcers (actually this was found by a static code checker)

so its a QA issue  not a bug fix in any way.

thx!
hofrat
