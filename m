Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaKYHws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:52:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaKYHwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:52:43 -0500
Date: Tue, 25 Nov 2014 10:52:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        oleg.drokin@intel.com, bergwolf@gmail.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Message-ID: <20141125075229.GC4893@mwanda>
References: <cover.1416853961.git.zahari.doychev@linux.com>
 <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>
 <20141124234036.GA4835@mwanda>
 <20141125073542.GN429@riot.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125073542.GN429@riot.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 08:35:42AM +0100, Zahari Doychev wrote:
> On Tue, Nov 25, 2014 at 02:40:36AM +0300, Dan Carpenter wrote:
> > On Mon, Nov 24, 2014 at 07:55:41PM +0100, Zahari Doychev wrote:
> > > --- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> > > +++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> > > @@ -784,7 +784,8 @@ lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
> > >  		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
> > >  		   unsigned int nob)
> > >  {
> > > -	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
> > > +	struct iovec diov = {/*.iov_base = */ (void __user *)dest,
> > > +			     /*.iov_len = */ dlen};
> > >  
> > 
> > Why can't we just make the comments into code by removing the /*
> > characters?  Remove the cast by declaring the data as __user data to
> > begin with instead of declaring it incorrectly and then casting to the
> > correct type later.
> 
> If I make the declarations right then I am moving the casts to other functions.

Yeah.  It might introduce new warnings.  Don't stress about that.  Don't
add casts, we'll just fix it all later.  It's better to have warnings
instead of hiding them with casts.

regards,
dan carpenter

