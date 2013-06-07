Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3FGKA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:00:59 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36651 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab3FGKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:00:56 -0400
Date: Fri, 7 Jun 2013 12:00:47 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130607100047.GM2566@localhost>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606173121.GA1866@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:31:21AM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> @@ -1040,11 +1044,10 @@ static int usb_serial_probe(struct usb_i
>  	 */
>  	serial->disconnected = 1;
>  
> -	if (get_free_serial(serial, num_ports, &minor) == NULL) {
> +	if (get_free_serial(serial, num_ports)) {
>  		dev_err(ddev, "No more free serial devices\n");
>  		goto probe_error;
>  	}
> -	serial->minor = minor;

This gives a warning as minor is no longer initialised, but is still
used to initialise the console a bit further down.

	usb_serial_console_init(minor);

Should probably just drop minor, and use serial->port[0]->minor instead.

Thanks,
Johan
