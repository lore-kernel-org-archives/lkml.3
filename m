Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaGVVX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:23:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaGVVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:23:55 -0400
Date: Tue, 22 Jul 2014 14:23:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Oczek <jeffoczek@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: cxt1e1: Fix static symbol sparse warnings for
 global vars in linux.c
Message-ID: <20140722212354.GA23566@kroah.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
 <20140722201722.GA20515@kroah.com>
 <20140722205658.GA7117@fofx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722205658.GA7117@fofx>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:56:59PM -0400, Jeff Oczek wrote:
> On Tue, Jul 22, 2014 at 01:17:22PM -0700, Greg KH wrote:
> > On Tue, Jul 22, 2014 at 04:07:51PM -0400, Jeff Oczek wrote:
> > > Put extern declarations in cxt1e1_common.h to reduce sparse warnings for linux.c:
> > 
> > I know you didn't name this variable, but wow, that's a horrid name for
> > a global variable :)
> > 
> > Any way you could change this to first fix up the name of the variable
> > to something a bit more "device-specific" first, before this patch?
> > 
> > Perhaps "cxt1e1_error_flag"?
> > 
> > > +extern int cxt1e1_max_mru;
> > > +extern int cxt1e1_max_mtu;
> > 
> > These are fine.
> > 
> > > +extern int max_mtu_default;
> > > +extern int max_txdesc_used;
> > > +extern int max_txdesc_default;
> > > +extern int max_rxdesc_used;
> > > +extern int max_rxdesc_default;
> > 
> > Again, these are bad names, can you do the same thing here?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> max_txdesc_used and max_rxdesc_used are module parameters, 

Ugh :(

> is it ok to change them?  I'm quite new to this -- I don't know if that
> would count as breaking userspace or not.

Yeah, we can't change them, good catch.

> If not allowed, I could go the route of changing these less descriptive ones
> to static in the main file and then make an assignment to the global vars
> during the module init.

That would be the best thing to do.

thanks,

greg k-h
