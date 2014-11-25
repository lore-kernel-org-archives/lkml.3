Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaKYHet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:34:49 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62030 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaKYHeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:34:46 -0500
Date: Tue, 25 Nov 2014 08:35:42 +0100
From: Zahari Doychev <zahari.doychev@linux.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        oleg.drokin@intel.com, bergwolf@gmail.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Message-ID: <20141125073542.GN429@riot.fritz.box>
References: <cover.1416853961.git.zahari.doychev@linux.com>
 <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>
 <20141124234036.GA4835@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124234036.GA4835@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 02:40:36AM +0300, Dan Carpenter wrote:
> On Mon, Nov 24, 2014 at 07:55:41PM +0100, Zahari Doychev wrote:
> > --- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> > +++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> > @@ -784,7 +784,8 @@ lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
> >  		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
> >  		   unsigned int nob)
> >  {
> > -	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
> > +	struct iovec diov = {/*.iov_base = */ (void __user *)dest,
> > +			     /*.iov_len = */ dlen};
> >  
> 
> Why can't we just make the comments into code by removing the /*
> characters?  Remove the cast by declaring the data as __user data to
> begin with instead of declaring it incorrectly and then casting to the
> correct type later.

If I make the declarations right then I am moving the casts to other functions.
I was not sure which one is better but it is not a problem I will fix this.

> 
> Also it's not allowed to send two patches with the exact same subject.
> Also the subject was sucky and too vague anyway.  :)

Sorry for that.

regards,
Zahari

> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
