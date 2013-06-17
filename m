Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3FQUu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:50:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3FQUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:50:54 -0400
Date: Mon, 17 Jun 2013 23:49:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Lorenz Haspel <lorenz@badgers.com>, devel@linuxdriverproject.org,
        gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 4/4 v2] silicom: checkpatch: errors caused by macros
Message-ID: <20130617204922.GM5008@mwanda>
References: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
 <1371496814-26104-1-git-send-email-lorenz@badgers.com>
 <1371498132.2213.7.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371498132.2213.7.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:42:12PM -0700, Joe Perches wrote:
> On Mon, 2013-06-17 at 21:20 +0200, Lorenz Haspel wrote:
> > fixed checkpatch error:
> > added parenthesis around complex macro.
> > 
> > Macro with return was only used once in the code,
> > so I expandet it in-place.
> []
> > diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> []
> > -#define lock_bpctl()					\
> > -if (down_interruptible(&bpctl_sema)) {			\
> > -	return -ERESTARTSYS;				\
> > -}							\
> > -
> >  #define unlock_bpctl()					\
> >  	up(&bpctl_sema);
> 
> Symmetry please.
> 
> Most likely, this unlock_bpctl macro is only used once too.
> I suggest removing it as well.
> 

Joe is right, of course, but this could be fixed in a later patch.

regards,
dan carpenter
