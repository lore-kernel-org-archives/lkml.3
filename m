Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab3DIQMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:12:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:45511 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719Ab3DIQMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="225108176"
Date: Tue, 9 Apr 2013 18:12:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20130409161222.GZ24058@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
 <1365438469.322553103@f51.mail.ru>
 <20130409072059.GC23447@zurbaran>
 <1365522460.690965802@f12.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365522460.690965802@f12.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tue, Apr 09, 2013 at 07:47:40PM +0400, Alexander Shiyan wrote:
> > On Mon, Apr 08, 2013 at 08:27:49PM +0400, Alexander Shiyan wrote:
> > > > > > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > > > > > failed like this:
> > > > > > 
> > > > > > drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> > > > > > drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> > > > > > 
> > > > > > Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> > > > > > 
> > > > > > I have used the mfd tree from next-20130405 for today.
> > > > > 
> > > > > This means that we do not have empty declarations for the
> > > > > of_xx functions in linux/of.h for !CONFIG_OF.
> > > > > OK to declare these functions or any other opinions?
> > > > Ok with me, but you'd need to get Grant and Rob's ACK.
> ...
> > > Subject: [PATCH] regulator: anatop: Make select dependency from
> > >  HAVE_IMX_ANATOP symbol
> > > 
> > > This patch make selection of anatop-regulator from HAVE_IMX_ANATOP
> > > kernel symbol. This fixes build kernel with syscon driver but without
> > > oftree support.
> ...
> > This does look like a band-aid solution to me. Yes, it will fix the crash, but
> > you're restricting this code to a much smaller architecture set. AFAIK
> > linux-next is not tested on that arch, for example.
> 
> OK, the second solution:
> 
> From 3296415f29818a430bad12c92dc65cd81e4d133f Mon Sep 17 00:00:00 2001
> From: Alexander Shiyan <shc_work@mail.ru>
> Date: Tue, 9 Apr 2013 19:41:27 +0400
> Subject: [PATCH] of: add stub of_get_parent for non-OF builds
> 
> Fixes build error on x86_64 allmodconfig, introduced by commit
> 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> 
> drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  include/linux/of.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a0f1292..9f5923f 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -353,6 +353,11 @@ static inline struct device_node *of_find_node_by_name(struct device_node *from,
>  	return NULL;
>  }
>  
> +static inline struct device_node *of_get_parent(const struct device_node *node)
> +{
> +	return NULL;
> +}
> +
That looks like a proper fix, but I'd like to get Grant or/and Rob's ACK for
it before merging it. Please look at MAINTAINERS and cc them on this thread.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
