Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3FGRZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:25:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3FGRZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:25:00 -0400
Date: Fri, 7 Jun 2013 10:24:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130607172458.GA29371@kroah.com>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607100047.GM2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607100047.GM2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:00:47PM +0200, Johan Hovold wrote:
> On Thu, Jun 06, 2013 at 10:31:21AM -0700, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > @@ -1040,11 +1044,10 @@ static int usb_serial_probe(struct usb_i
> >  	 */
> >  	serial->disconnected = 1;
> >  
> > -	if (get_free_serial(serial, num_ports, &minor) == NULL) {
> > +	if (get_free_serial(serial, num_ports)) {
> >  		dev_err(ddev, "No more free serial devices\n");
> >  		goto probe_error;
> >  	}
> > -	serial->minor = minor;
> 
> This gives a warning as minor is no longer initialised, but is still
> used to initialise the console a bit further down.
> 
> 	usb_serial_console_init(minor);
> 
> Should probably just drop minor, and use serial->port[0]->minor instead.

Ah crap, I knew I was going to have to convert the console code, but I
just forgot about it as I didn't have it selected so I didn't get any
build errors...

I'll go fix that up and do a v3 of the patches...

greg k-h
