Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbaDHNxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:53:21 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43323 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbaDHNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:53:19 -0400
Date: Tue, 8 Apr 2014 15:52:47 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Xiao Jin <jin.xiao@intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140408135247.GF25779@localhost>
References: <53436770.9090008@intel.com>
 <20140408073306.GB25779@localhost>
 <1396953211.25633.16.camel@linux-fkkt.site>
 <20140408131718.GE25779@localhost>
 <1396964322.25633.21.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396964322.25633.21.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > If I see this correctly, then ASYNCB_INITIALIZED is cleared in
> > > tty_port_close() we is called from acm_tty_close(). Thus it should
> > > be enough to make sure that the device is resumed at the beginning
> > > of acm_tty_close() and acm_resume() will do the job automatically.
> > > What do you think?
> > 
> > But the device should already be about to be resumed, right? If the port
> 
> Yes.
> 
> > is closed fast enough that resume hasn't had time to run before
> > shutdown is called I think the right thing to do is simply to discard
> > the delayed bytes (in shutdown).
> 
> I think if we said we have transmitted then we should do so.

We haven't made any such promises -- only that we've buffered the data.
Just like any write urb can be cancelled at close / shutdown before
having been transmitted.

The user needs to use closing_wait or drain_delay to give the buffers a
chance to empty. If not used at all, or we get a time out, then the data
should be discarded.

Johan
