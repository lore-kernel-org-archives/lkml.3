Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaG0Rkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:40:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60665 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaG0Rky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:40:54 -0400
Date: Sun, 27 Jul 2014 19:40:49 +0200
From: Nicolas Thery <nthery@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, marek.belisko@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix some checkpatch complaints
Message-ID: <20140727174049.GA5580@ubuntu>
References: <1406480913-31378-1-git-send-email-nthery@gmail.com>
 <1406481833.5285.6.camel@joe-AO725>
 <20140727173538.GA27056@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140727173538.GA27056@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 10:35:38AM -0700, Greg KH wrote:
> On Sun, Jul 27, 2014 at 10:23:53AM -0700, Joe Perches wrote:
> > On Sun, 2014-07-27 at 19:08 +0200, Nicolas Thery wrote:
> > > This patch fixes the following errors and warnings:
> > []
> > > diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
> > []
> > > @@ -23,34 +23,38 @@
> > []
> > > -#define seq_putx(m, message, size, var) \
> > > +#define seq_putx(m, message, size, var) do { \
> > >  	seq_printf(m, message);	\
> > >  	for (i = 0; i < (size - 1); i++) { \
> > >  		seq_printf(m, "%02x:", var[i]); \
> > >  	} \
> > > -	seq_printf(m, "%02x\n", var[i])
> > > +	seq_printf(m, "%02x\n", var[i]); \
> > > +} while (0)
> > 
> > Ideally, these wouldn't depend on an external
> > i variable.
> > 
> > Maybe something like:
> > 
> > #define seq_putx(m, message, size, var) \
> > do { \
> > 	int _i; \
> >  	seq_printf(m, message);	\
> >  	for (_i = 0; _i < (size - 1); _i++) \
> >  		seq_printf(m, "%02x:", var[_i]); \
> > 	seq_printf(m, "%02x\n", var[_i]); \
> > } while (0)
> >  
> > > -#define seq_putd(m, message, size, var) \
> > > +#define seq_putd(m, message, size, var) do { \
> > >  	seq_printf(m, message); \
> > >  	for (i = 0; i < (size - 1); i++) { \
> > >  		seq_printf(m, "%d.", var[i]); \
> > >  	} \
> > > -	seq_printf(m, "%d\n", var[i])
> > > +	seq_printf(m, "%d\n", var[i]); \
> > > +} while (0)
> > 
> > Maybe later change these to use the recently introduced
> > seq_hex_dump: https://lkml.org/lkml/2014/7/11/269
> > 
> 
> How about removing the proc files entirely, as I doubt they are really
> needed :)

Okay.  I'll do this.

Thanks to both of you for the review.
