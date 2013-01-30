Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3A3Nav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:30:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:55031 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab3A3Nat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:30:49 -0500
Date: Wed, 30 Jan 2013 14:32:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 10/11] staging/fwserial: Fix premature unthrottle
Message-ID: <20130130133240.GA16591@kroah.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
 <1359430485-5301-10-git-send-email-peter@hurleysoftware.com>
 <20130130042947.GA25371@kroah.com>
 <1359551465.3325.14.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359551465.3325.14.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 08:11:05AM -0500, Peter Hurley wrote:
> On Tue, 2013-01-29 at 23:29 -0500, Greg Kroah-Hartman wrote:
> > On Mon, Jan 28, 2013 at 10:34:44PM -0500, Peter Hurley wrote:
> > > The unthrottle may restart the writer before the rx push
> > > has a chance to start emptying the rx buffer, resulting in an
> > > overflowed rx buffer and lost data.
> > > 
> > > Perform the actual device unthrottle with the rx push instead.
> > > 
> > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > > ---
> > >  drivers/staging/fwserial/fwserial.c | 30 ++++++++++++++----------------
> > >  1 file changed, 14 insertions(+), 16 deletions(-)
> > 
> > this patch fails to apply to my tree, but the 9 previous ones were fine,
> > so I'll not apply it, or ght 11/11 patch.  Care to fix it up and resend
> > both of them?
> 
> Hi Greg,
> 
> I can rebase these against your staging-next, if you'd prefer, but it
> will make the -next merge non-trivial.
> 
> Your tty-next tree is carrying patches to this driver from patch series
>   "TTY: switch flipping functions to tty_port"
> which is already in -next.
> 
> Let me know what you'd like me to do.

Ugh, that's a mess.

Can these wait until after 3.9-rc1 is out?  If so, things should get
synced up by then.  Otherwise I'll have to figure out how to handle the
merge properly...

thanks,

greg k-h
