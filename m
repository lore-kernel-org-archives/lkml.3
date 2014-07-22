Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaGVU5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:57:05 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46280 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbaGVU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:57:03 -0400
Date: Tue, 22 Jul 2014 16:56:59 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: cxt1e1: Fix static symbol sparse warnings for
 global vars in linux.c
Message-ID: <20140722205658.GA7117@fofx>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
 <20140722201722.GA20515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722201722.GA20515@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:17:22PM -0700, Greg KH wrote:
> On Tue, Jul 22, 2014 at 04:07:51PM -0400, Jeff Oczek wrote:
> > Put extern declarations in cxt1e1_common.h to reduce sparse warnings for linux.c:
> 
> I know you didn't name this variable, but wow, that's a horrid name for
> a global variable :)
> 
> Any way you could change this to first fix up the name of the variable
> to something a bit more "device-specific" first, before this patch?
> 
> Perhaps "cxt1e1_error_flag"?
> 
> > +extern int cxt1e1_max_mru;
> > +extern int cxt1e1_max_mtu;
> 
> These are fine.
> 
> > +extern int max_mtu_default;
> > +extern int max_txdesc_used;
> > +extern int max_txdesc_default;
> > +extern int max_rxdesc_used;
> > +extern int max_rxdesc_default;
> 
> Again, these are bad names, can you do the same thing here?
> 
> thanks,
> 
> greg k-h

Hi Greg,

max_txdesc_used and max_rxdesc_used are module parameters, 
is it ok to change them?  I'm quite new to this -- I don't know if that
would count as breaking userspace or not.

If not allowed, I could go the route of changing these less descriptive ones
to static in the main file and then make an assignment to the global vars
during the module init.

Or I can just leave the module params be and change the other globals.

Any of those sound good?

Thanks,
Jeff
