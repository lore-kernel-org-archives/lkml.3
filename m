Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JJRiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:38:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3JJRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:38:49 -0400
Date: Thu, 10 Oct 2013 10:38:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] sysfs/bin: Fix size handling overflow for bin_attribute
Message-ID: <20131010173847.GD13759@kroah.com>
References: <1381378788.4330.30.camel@pasglop>
 <1381388635.4330.37.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381388635.4330.37.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 06:03:55PM +1100, Benjamin Herrenschmidt wrote:
> While looking at the code, I noticed that bin_attribute read() and write()
> ops copy the inode size into an int for futher comparisons.
> 
> Some bin_attributes can be fairly large. For example, pci creates some for
> BARs set to the BAR size and giant BARs are around the corner, so this is
> going to break something somewhere eventually.
> 
> Let's use the right type.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This file (fs/sysfs/bin.c) is no longer in linux-next as Tejun merged it
with the other file handling code in sysfs, to remove a bunch of
duplicated logic.

So, could you look at linux-next and see if this is still an issue there
or not?

thanks,

greg k-h
