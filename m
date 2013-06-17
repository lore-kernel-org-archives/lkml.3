Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3FQVDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:03:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41551 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540Ab3FQVDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:03:47 -0400
Message-ID: <1371503023.2213.9.camel@joe-AO722>
Subject: Re: [PATCH 4/4 v2] silicom: checkpatch: errors caused by macros
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lorenz Haspel <lorenz@badgers.com>, devel@linuxdriverproject.org,
        gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Date: Mon, 17 Jun 2013 14:03:43 -0700
In-Reply-To: <20130617204922.GM5008@mwanda>
References: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
	 <1371496814-26104-1-git-send-email-lorenz@badgers.com>
	 <1371498132.2213.7.camel@joe-AO722> <20130617204922.GM5008@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 23:49 +0300, Dan Carpenter wrote:
> On Mon, Jun 17, 2013 at 12:42:12PM -0700, Joe Perches wrote:
> > On Mon, 2013-06-17 at 21:20 +0200, Lorenz Haspel wrote:
> > > fixed checkpatch error:
> > > added parenthesis around complex macro.
> > > 
> > > Macro with return was only used once in the code,
> > > so I expandet it in-place.
> > []
> > > diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> > []
> > > -#define lock_bpctl()					\
> > > -if (down_interruptible(&bpctl_sema)) {			\
> > > -	return -ERESTARTSYS;				\
> > > -}							\
> > > -
> > >  #define unlock_bpctl()					\
> > >  	up(&bpctl_sema);
> > 
> > Symmetry please.
> > 
> > Most likely, this unlock_bpctl macro is only used once too.
> > I suggest removing it as well.
> > 
> 
> Joe is right, of course, but this could be fixed in a later patch.

Generally I think it's better that new submitters patches
should go through more strict reviews and be as correct
as possible.  I think this is especially true for patches
that are just checkpatch driven.

