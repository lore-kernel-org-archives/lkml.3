Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3HCJVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 05:21:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3HCJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 05:21:15 -0400
Date: Sat, 3 Aug 2013 17:22:31 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Platschek <andi.platschek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: only call kfree() if memory was allocated
Message-ID: <20130803092231.GA1870@kroah.com>
References: <1375479830-8698-1-git-send-email-andi.platschek@gmail.com>
 <20130802220445.GA22019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802220445.GA22019@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 06:04:45AM +0800, Greg KH wrote:
> On Fri, Aug 02, 2013 at 11:43:50PM +0200, Andreas Platschek wrote:
> > There are several cases where we could bail out of show_uevent()
> > before kzalloc() is even called. In those cases we don't want to
> > call kfree().
> 
> Why not?  It's totally safe to do that.
> 
> > In addition the error handling of kzalloc() is now using the
> > single point of exit as well.
> 
> We had the single point of exit to start with, there's no change made
> there.

Oops, no, you are correct about that one, but it's not really a big deal
for such a small function.

greg k-h
