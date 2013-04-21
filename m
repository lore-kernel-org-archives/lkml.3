Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3DUNTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 09:19:07 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753398Ab3DUNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 09:19:05 -0400
Date: Sun, 21 Apr 2013 08:19:02 -0500
From: Robin Holt <holt@sgi.com>
To: walter harms <wharms@bfs.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] gru: info leak in gru_get_config_info()
Message-ID: <20130421131902.GT3658@sgi.com>
References: <20130421111031.GE6171@elgon.mountain>
 <5173D409.8010405@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5173D409.8010405@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 01:56:57PM +0200, walter harms wrote:
> 
> 
> Am 21.04.2013 13:10, schrieb Dan Carpenter:
> > The "info.fill" array isn't initialized so it can leak uninitialized
> > stack information to user space.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
> > index 44d273c..ed5fc43 100644
> > --- a/drivers/misc/sgi-gru/grufile.c
> > +++ b/drivers/misc/sgi-gru/grufile.c
> > @@ -176,6 +176,7 @@ static long gru_get_config_info(unsigned long arg)
> >  	info.nodes = num_online_nodes();
> >  	info.blades = info.nodes / nodesperblade;
> >  	info.chiplets = GRU_CHIPLETS_PER_BLADE * info.blades;
> > +	memset(&info.fill, 0, sizeof(info.fill));
> >  
> 
> the other way around (clear first all bytes) looks more easy
> in case someone will add more elements to the struct.
> 
> memset(&info, 0, sizeof(info));
> info.nodes = num_online_nodes();
> info.blades = info.nodes / nodesperblade;

That does seem more safe.

Robin
