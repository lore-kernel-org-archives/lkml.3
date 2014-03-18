Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaCRUjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:39:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaCRUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:39:22 -0400
Date: Tue, 18 Mar 2014 13:41:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Silvio F <silvio.fricke@gmail.com>, linux-kernel@vger.kernel.org,
        daeseok.youn@gmail.com, silvio@port1024.net
Subject: Re: [PATCH] staging: unisys: kmalloc/memset to kzalloc conversation
Message-ID: <20140318204124.GB26473@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <1395173271-13190-1-git-send-email-silvio.fricke@gmail.com>
 <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
 <1395173845.2812.82.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395173845.2812.82.camel@joe-AO722>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 01:17:25PM -0700, Joe Perches wrote:
> On Tue, 2014-03-18 at 21:07 +0100, Silvio F wrote:
> > This patch solves the Coccinelle warning: "kzalloc should be used
> > instead of kmalloc/memset"
> []
> > diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
> []
> > @@ -190,10 +190,7 @@ struct chaninfo {
> >  }
> >  
> >  #define ALLOC_CMDRSP(cmdrsp) { \
> > -	cmdrsp = kmalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
> > -	if (cmdrsp != NULL) { \
> > -		memset(cmdrsp, 0, SIZEOF_CMDRSP); \
> > -	} \
> > +	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
> >  }
> 
> It'd be nicer to get rid of this macro altogether
> and substitute kzalloc in the 3 places it's used.

Yes, that's the better thing to do overall.

thanks,

greg k-h
