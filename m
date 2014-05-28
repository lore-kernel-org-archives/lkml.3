Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaE1U3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:29:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaE1U3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:29:13 -0400
Date: Wed, 28 May 2014 13:32:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] tty/hvc/hvc_console: Fix wakeup of HVC thread on
 hvc_kick()
Message-ID: <20140528203248.GA14431@kroah.com>
References: <1400838066.29150.69.camel@pasglop>
 <1401235290.8262.9.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401235290.8262.9.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:01:30AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2014-05-23 at 19:41 +1000, Benjamin Herrenschmidt wrote:
> > Some backends call hvc_kick() to wakeup the HVC thread from its
> > slumber upon incoming characters. This however doesn't work
> > properly because it uses msleep_interruptible() which is mostly
> > immune to wake_up_process(). It will basically go back to sleep
> > until the timeout is expired (only signals can really wake it).
> >
> > Replace it with a simple shedule_timeout_interruptible() instead,
> > which may wakeup earlier every now and then but we really don't
> > care in this case.
> 
> Nobody commented ? :-)
> 
> Greg, do you want to take this in the tty tree or can I stick it in
> powerpc ?

I'll take it, thanks.

greg k-h
