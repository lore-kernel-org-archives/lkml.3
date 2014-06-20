Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaFTPKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:10:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaFTPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:10:28 -0400
Date: Fri, 20 Jun 2014 08:14:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: crystalhd: Do not mix integers and user pointers
Message-ID: <20140620151429.GA18348@kroah.com>
References: <1403262977-26100-1-git-send-email-lkundrak@v3.sk>
 <20140620113426.GU5500@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620113426.GU5500@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:34:26PM +0300, Dan Carpenter wrote:
> On Fri, Jun 20, 2014 at 01:16:17PM +0200, Lubomir Rintel wrote:
> > Fixes the following sparse warnings:
> > 
> >   crystalhd/crystalhd_lnx.c:227:61: warning: incorrect type in argument 3 (different base types)
> >   crystalhd/crystalhd_lnx.c:227:61:    expected unsigned long [unsigned] ua
> >   crystalhd/crystalhd_lnx.c:227:61:    got void [noderef] <asn:1>*ua
> >   crystalhd/crystalhd_lnx.c:229:65: warning: incorrect type in argument 4 (different base types)
> >   crystalhd/crystalhd_lnx.c:229:65:    expected unsigned long [unsigned] ua
> >   crystalhd/crystalhd_lnx.c:229:65:    got void [noderef] <asn:1>*ua
> > 
> > Done for the Eudyptula challenge.
> > 
> 
> This patch is nice and fixes a bunch of warnings.
> 
> Normally, I would might you to redo it and remove the no longer needed
> casts for ua_off as well...
> 
> 	crystalhd_user_data((void __user *)ua_off, io->add_cdata,
>                             ^^^^^^^^^^^^^^^
> But we are going to delete this entire driver soon.  We may as well
> apply yours as is and then delete it or just delete the driver without
> applying this cleanup.

Yeah, I'm just going to go delete this driver right now, so I will not
apply this patch, sorry :(

greg k-h
