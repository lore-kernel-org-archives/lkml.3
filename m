Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3C0JfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:35:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3C0JfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:35:09 -0400
Date: Wed, 27 Mar 2013 09:35:05 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 098/150] USB: serial: add modem-status-change wait queue
Message-ID: <20130327093505.GA3103@hercules>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
 <1364311249-14454-99-git-send-email-luis.henriques@canonical.com>
 <20130326153118.GE9739@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326153118.GE9739@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:31:18PM +0100, Johan Hovold wrote:
> On Tue, Mar 26, 2013 at 03:19:57PM +0000, Luis Henriques wrote:
> > 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
> 
> This patch is incorrect as the wait-queue initialisation is missing. A
> fix has been posted to linux-usb:
> 
> 	http://marc.info/?l=linux-usb&m=136428758202815&w=2
> 
> and should show up in 3.9-rc5. This patch and the following
> use-after-free patches should not be applied without that fix.

Ups, I missed that.  Thanks Johan, I'll drop these patches for now and
will queued them again to 3.5 later.

Cheers,
--
Luis


> 
> Johan
> 
> > ------------------
> > 
> > From: Johan Hovold <jhovold@gmail.com>
> > 
> > commit e5b33dc9d16053c2ae4c2c669cf008829530364b upstream.
> > 
> > Add modem-status-change wait queue to struct usb_serial_port that
> > subdrivers can use to implement TIOCMIWAIT.
> > 
> > Currently subdrivers use a private wait queue which may have been
> > released when waking up after device disconnected.
> > 
> > Note that we're adding a new wait queue rather than reusing the tty-port
> > one as we do not want to get woken up at hangup (yet).
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  include/linux/usb/serial.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> > index 86c0b45..0b61f01 100644
> > --- a/include/linux/usb/serial.h
> > +++ b/include/linux/usb/serial.h
> > @@ -66,6 +66,7 @@
> >   *	port.
> >   * @flags: usb serial port flags
> >   * @write_wait: a wait_queue_head_t used by the port.
> > + * @delta_msr_wait: modem-status-change wait queue
> >   * @work: work queue entry for the line discipline waking up.
> >   * @throttled: nonzero if the read urb is inactive to throttle the device
> >   * @throttle_req: nonzero if the tty wants to throttle us
> > @@ -112,6 +113,7 @@ struct usb_serial_port {
> >  
> >  	unsigned long		flags;
> >  	wait_queue_head_t	write_wait;
> > +	wait_queue_head_t	delta_msr_wait;
> >  	struct work_struct	work;
> >  	char			throttled;
> >  	char			throttle_req;
