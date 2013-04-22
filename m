Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3DVQlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:41:21 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48903 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977Ab3DVQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:41:20 -0400
Date: Mon, 22 Apr 2013 11:41:18 -0500
From: Robin Holt <holt@sgi.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        walter harms <wharms@bfs.de>
Subject: Re: [patch v2] gru: info leak in gru_get_config_info()
Message-ID: <20130422164118.GO3672@sgi.com>
References: <20130421131902.GT3658@sgi.com>
 <20130421170107.GA16118@elgon.mountain>
 <20130421173334.GA9023@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421173334.GA9023@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Robin Holt <holt@sgi.com>
On Sun, Apr 21, 2013 at 12:33:34PM -0500, Dimitri Sivanich wrote:
> Acked-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> On Sun, Apr 21, 2013 at 08:01:07PM +0300, Dan Carpenter wrote:
> > The "info.fill" array isn't initialized so it can leak uninitialized
> > stack information to user space.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: style changes
> > 
> > diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
> > index 44d273c..0535d1e 100644
> > --- a/drivers/misc/sgi-gru/grufile.c
> > +++ b/drivers/misc/sgi-gru/grufile.c
> > @@ -172,6 +172,7 @@ static long gru_get_config_info(unsigned long arg)
> >  		nodesperblade = 2;
> >  	else
> >  		nodesperblade = 1;
> > +	memset(&info, 0, sizeof(info));
> >  	info.cpus = num_online_cpus();
> >  	info.nodes = num_online_nodes();
> >  	info.blades = info.nodes / nodesperblade;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
