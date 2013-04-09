Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936559Ab3DIWLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:11:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761010Ab3DIWLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:11:34 -0400
Date: Wed, 10 Apr 2013 00:11:32 +0200
From: Jan Kara <jack@suse.cz>
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: I/O blocked while dirty pages are being flushed
Message-ID: <20130409221132.GE15214@quack.suse.cz>
References: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
 <514ED516.4020009@acm.org>
 <alpine.DEB.2.02.1303250827120.4028@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303250827120.4028@shack.dolda2000.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-03-13 08:31:43, Fredrik Tolf wrote:
> On Sun, 24 Mar 2013, Bart Van Assche wrote:
> >On 03/24/13 06:12, Fredrik Tolf wrote:
> >>While this flush is running, I find that many a process goes into disk
> >>sleep waiting for the flush to complete. This includes the process
> >>manipulating the mmapped file whenever it tries to redirty a page
> >>currently waiting to be flushed, but also, for instance, programs that
> >>write() to log files (since, I guess, the buffer page backing the last
> >>written portion of the log file is being flushed).
> >
> >Had you already encountered this article: Jonathan Corbet, The
> >trouble with stable pages, March 13, 2012
> >(http://lwn.net/Articles/486311/) ?
> 
> I had not, but that certainly does seem to be the exact problem I'm
> having. Thanks for the link; it was a very interesting read! Does
> anyone know if any progress has been made since about any resolution
> of the situation?
  Patches to fix the situation are already merged in Linus' tree and will
be in 3.9. So stay tuned...

> I notice linked mail threads with people saying that they have
> simply removed the calls to wait_on_page_writeback to resolve their
> problems. Can this still be considered safe, or have other systems
> than this block-device checksumming started depending on stable
> pages since? Like software RAID, for instance?
  It should be safe. Noone except HW really realies on stable pages (or
better, they do the copying if they do need it).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
