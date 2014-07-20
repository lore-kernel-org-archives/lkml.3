Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaGTLDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:03:11 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:50759 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGTLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:03:09 -0400
Date: Sun, 20 Jul 2014 13:03:04 +0200
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, oleg.drokin@intel.com, josh@joshtriplett.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: lustre/lustre/lov: Remove unneeded 'if'
 statement in lov_request.c/lov_check_set()
Message-ID: <20140720110304.GB12613@rlp>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
 <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
 <1405799962.14358.114.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405799962.14358.114.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 12:59:22PM -0700, Joe Perches wrote:
> On Sat, 2014-07-19 at 21:34 +0200, Riccardo Lucchese wrote:
> > It is silly to go through an if statement to set a single boolean
> > value in function of a single boolean expression. In the function
> > lov_check_set, assign the return value directly.
> []
> > diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
> []
> > @@ -140,14 +140,13 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
> >  
> >  static int lov_check_set(struct lov_obd *lov, int idx)
> >  {
> > -	int rc = 0;
> > +	int rc;
> >  	mutex_lock(&lov->lov_lock);
> >  
> > -	if (lov->lov_tgts[idx] == NULL ||
> > -	    lov->lov_tgts[idx]->ltd_active ||
> > -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> > -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> > -		rc = 1;
> > +	rc = lov->lov_tgts[idx] == NULL ||
> > +		lov->lov_tgts[idx]->ltd_active ||
> > +		(lov->lov_tgts[idx]->ltd_exp != NULL &&
> > +		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);
> >  
> >  	mutex_unlock(&lov->lov_lock);
> >  	return rc;
> 
> Maybe consider using a temporary for lov->lov_tgtx[idx] like:
[...]

Indeed, it is nicer this way.

Thanks,
Riccardo
