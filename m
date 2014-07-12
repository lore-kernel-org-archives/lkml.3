Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaGLCLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:11:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaGLCLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:11:02 -0400
Date: Fri, 11 Jul 2014 19:15:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712021529.GA17548@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712015327.GA26496@kroah.com>
 <1405130244.6751.32.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405130244.6751.32.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:57:24PM -0700, Joe Perches wrote:
> On Fri, 2014-07-11 at 18:53 -0700, Greg KH wrote:
> > On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > > A simple script to run checkpatch --fix for various types of
> > > of cleanups.
> []
> > Anyway, try running this script on
> > drivers/staging/lustre/lnet/lnet/acceptor.c to see how this build fails.
> 
> lustre doesn't use "normal" kernel makefiles.

Well, it does, it just has a:
	subdir-ccflags-y := -I$(src)/include/
line in drivers/staging/lustre/Makefile that messes up making .o files
in subdirectories.

I'll go fix that include file mess up now to be able to remove that line
so the the .o file building will work.

thanks,

greg k-h
