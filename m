Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaFTUbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:31:23 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:46204 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaFTUbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:31:21 -0400
Date: Fri, 20 Jun 2014 16:31:18 -0400
From: "James A. Shackleford" <shack@linux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6655: update out-of-date function
 declaration
Message-ID: <20140620203118.GA13042@xps>
References: <1401675573-27734-1-git-send-email-shack@linux.com>
 <20140619233502.GA10708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619233502.GA10708@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:35:02PM -0700, Greg KH wrote:
> On Sun, Jun 01, 2014 at 10:19:31PM -0400, James A Shackleford wrote:
> > The function iwctl_siwscan() is defined in iwctl.c as:
> > int iwctl_siwscan(struct net_device *dev,
> > 		  struct iw_request_info *info,
> > 		  struct iw_point *wrq,
> > 		  char *extra)
> > {
> >   ...
> > 
> > This patch updates iwctl.h so that the type of the 3rd parameter (*wqr) in the
> > function declaration matches the definition.
> > 
> > Signed-off-by: James A Shackleford <shack@linux.com>
> > ---
> >  drivers/staging/vt6655/iwctl.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
> > index 871bd7c..4ad5e48 100644
> > --- a/drivers/staging/vt6655/iwctl.h
> > +++ b/drivers/staging/vt6655/iwctl.h
> > @@ -168,7 +168,7 @@ int iwctl_giwscan(struct net_device *dev,
> >  
> >  int iwctl_siwscan(struct net_device *dev,
> >  		  struct iw_request_info *info,
> > -		  struct iw_param *wrq,
> > +		  struct iw_point *wrq,
> >  		  char *extra);
> >  
> 
> Why isn't the compiler catching this issue?  Should something include
> this .h file?
> 
> thanks,
> 
> greg k-h

The declaration for iwctl_siwscan(), along with quite a few other declarations,
should be removed from this header and their functions made static within
iwctl.c  I will put another patch together that further cleans this up.
 
-James
