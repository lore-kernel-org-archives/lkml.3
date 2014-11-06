Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaKFUih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:38:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaKFUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:38:33 -0500
Date: Thu, 6 Nov 2014 12:38:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, stable@vger.kernel.org
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in
 receive path
Message-ID: <20141106203832.GB30170@kroah.com>
References: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
> The current implementation of put_tty_queue() causes a race condition
> when re-arranged by the compiler.
> 
> On my build with gcc 4.8.3, cross-compiling for ARM, the line
> 
> 	*read_buf_addr(ldata, ldata->read_head++) = c;
> 
> was re-arranged by the compiler to something like
> 
> 	x = ldata->read_head
> 	ldata->read_head++
> 	*read_buf_addr(ldata, x) = c;
> 
> which causes a race condition. Invalid data is read if data is read
> before it is actually written to the read buffer.

Really?  A compiler can rearange things like that and expect things to
actually work?  How is that valid?

Is this the "broken gcc" version that ARM developers keep running into
all the time with odd crashes and problems?  Can you upgrade to 4.9 and
see if that solves the issue for you?

thanks,

greg k-h
