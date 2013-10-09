Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3JIG6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:58:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3JIG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:58:05 -0400
Date: Tue, 8 Oct 2013 23:54:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
Message-ID: <20131009065404.GA7005@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
 <20131009054335.GA3525@kroah.com>
 <1381299404.2040.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381299404.2040.19.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:16:44PM -0700, Joe Perches wrote:
> On Tue, 2013-10-08 at 22:43 -0700, Greg KH wrote:
> > On Tue, Oct 08, 2013 at 10:32:27PM -0700, Joe Perches wrote:
> > > Currently, devm_ managed memory only supports kzalloc.
> > > 
> > > Convert the devm_kzalloc implementation to devm_kmalloc
> > > and remove the complete memset to 0 but still set the
> > > initial struct devres header and whatever padding before
> > > data to 0.
> > > 
> > > Add the other normal alloc variants as static inlines with
> > > __GFP_ZERO added to the gfp flag where appropriate:
> > > 
> > > 	devm_kzalloc
> > > 	devm_kcalloc
> > > 	devm_kmalloc_array
> > > 
> > > Add gfp.h to device.h for the newly added static inlines.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  drivers/base/devres.c  | 27 ++++++++++++++++-----------
> > >  include/linux/device.h | 21 +++++++++++++++++++--
> > >  2 files changed, 35 insertions(+), 13 deletions(-)
> > 
> > Makes sense to me, does this let other drivers start to use this where
> > they were not able to in the past?
> 
> Yes.
> 
> There are some existing uses of devm_kzalloc(dev, n*size, gfp)
> that could/should be converted.

Ok, great, want me to take the "RFC" off of this and apply it to my
tree?

greg k-h
