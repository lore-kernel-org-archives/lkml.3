Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3IXIwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:52:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3IXIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:52:27 -0400
Date: Tue, 24 Sep 2013 01:52:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-usb@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>,
        "open list:USB MASS STORAGE..." 
	<usb-storage@lists.one-eyed-alien.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] uas: make work list per-device
Message-ID: <20130924085227.GF11858@infradead.org>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
 <1379071635-30701-4-git-send-email-kraxel@redhat.com>
 <20130917203012.GA1752@infradead.org>
 <1379489584.12907.11.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379489584.12907.11.camel@nilsson.home.kraxel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 09:33:04AM +0200, Gerd Hoffmann wrote:
> > > While being at it rename the list head from "list" to "work", preparing
> > > for the addition of a second list.
> > 
> > Why do you even the list?
> 
> The list was already there when I took over maintainance ...
> 
> > What would a ordered per-device workqueue not
> > provide?
> 
> Had no reason to look into replacing the list with something else so
> far.  Why do you suggest using a workqueue instead?
> 
> Note that the list is not used in a typical request workflow.  Only in
> case queuing an usb urb failed the request is linked into the list and
> the worker will try to submit the usb urb again.

The driver is only using the list to queue up things into workqueue
context as far as I can see.  Which means it's far easier to leave that
to the workqueue.

