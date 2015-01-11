Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbbAKFYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 00:24:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbAKFYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 00:24:30 -0500
Date: Sat, 10 Jan 2015 21:24:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: Convert direct LOGERR uses to pr_err
Message-ID: <20150111052428.GC24038@kroah.com>
References: <1420945742.16787.12.camel@perches.com>
 <20150111041319.GB22334@kroah.com>
 <1420952121.32288.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420952121.32288.1.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 08:55:21PM -0800, Joe Perches wrote:
> On Sat, 2015-01-10 at 20:13 -0800, Greg Kroah-Hartman wrote:
> > On Sat, Jan 10, 2015 at 07:09:02PM -0800, Joe Perches wrote:
> > > Use the normal logging facility instead of a new macro.
> > > 
> > > Miscellanea:
> > > 
> > > o Realign arguments
> > > o Remove unnecessary alloc error messages as alloc failures
> > >   already emits a generic OOM message with a dump_stack
> > > o Add missing newlines to these messages to avoid interleaving
> > > o Spelling/typo fixes in those messages
> []
> > I rejected the other patch that did much this same thing, almost all of
> > these should be converted to use dev_* calls instead of pr_* calls, as
> > this is a driver, and drivers should always have access to a struct
> > device.  If not, they need to be fixed.
> 
> Baby steps.
> 
> This one prevents interleaving
> and fixes typos.

Yes, but converting it to dev_* at the same time saves a step, and gets
it done properly.  Leaving messages at pr_* levels takes away the
checkpatch warning, which makes the code "seem" to be acceptable.

sorry,

greg k-h
