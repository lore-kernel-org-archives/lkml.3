Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbaDPUZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:25:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbaDPUZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:25:51 -0400
Date: Wed, 16 Apr 2014 13:25:54 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: fix uart PORT_UNKNOWN handling
Message-ID: <20140416202554.GB25148@kroah.com>
References: <alpine.LNX.2.00.1404091151430.6519@lxtpfaff.pcs.ditec.de>
 <20140409133909.2073453a@alan.etchedpixels.co.uk>
 <alpine.LNX.2.00.1404091655140.29879@lxtpfaff.pcs.ditec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1404091655140.29879@lxtpfaff.pcs.ditec.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:06:24PM +0200, Thomas Pfaff wrote:
> 
> On Wed, 9 Apr 2014, One Thousand Gnomes wrote:
> 
> > On Wed, 9 Apr 2014 13:22:14 +0200
> > Thomas Pfaff <tpfaff@pcs.com> wrote:
> > 
> > > 1. uart_change_pm ist called during uart_open and calls the uart pm function
> > >    without checking for PORT_UNKNOWN.
> > 
> > Removing this breaks other parts of the code assume that the port will be
> > powered up (notably setserial paths). So it makes sense that
> > uart_change_pm for a "none" port is a no-op but needs logic in the
> > setserial path to power up a port when we move none->known and power it
> > down on known->none
> > 
> 
> Then why not move uart_change_pm into uart_port_startup, where it will be called 
> when needed ?
> A reworked patch is below.
> 
> > > 2. uart_shutdown is called from uart_set_info and does not check it either.
> > 
> > I don't see why this one matters. We would have done
> > 
> > 	uart_startup
> > 		uart_port_startup
> > 			uport->type == PORT_UNKNOWN
> > 			return 1;
> > 		ASYNCB_INITIALIZED is not set
> > 
> > 	uart_shutdown
> > 		ASYNCB_INITIALISED is not set
> > 			Skip call to uart_port_shutdown
> > 
> > So that code looks correct to me.
> 
> I agree, i have overlooked this.
> 
> Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>

Can you resend this in a format that I can apply this in?

thanks,

greg k-h
