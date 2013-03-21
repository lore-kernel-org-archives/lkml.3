Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab3CUNYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:24:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:49113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab3CUNYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,886,1355126400"; 
   d="scan'208";a="309972228"
Date: Thu, 21 Mar 2013 15:24:15 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] serial: of_serial: Handle fifosize property
Message-ID: <20130321132415.GA2902@xps8300>
References: <20130321104651.GC2862@xps8300>
 <1363862880-17295-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1363866099.2289.8.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363866099.2289.8.camel@leyfoon-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 21, 2013 at 07:41:39PM +0800, Ley Foon Tan wrote:
> On Thu, 2013-03-21 at 12:48 +0200, Heikki Krogerus wrote:
> > +	/* Check for fifo size */
> > +	if (of_property_read_u32(np, "fifosize", &prop) == 0)
> > +		port->fifosize = prop;
> > +
> Suggest to use "fifo-size" for the device tree property, to align with
> other DT properties.

I was going to, but then I noticed that in some .dtsi files "fifosize"
is used with uarts. Should I still change it?

> >  	port->irq = irq_of_parse_and_map(np, 0);
> >  	port->iotype = UPIO_MEM;
> >  	if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
> 
> I think you need to remove the UPF_FIXED_TYPE from port-flags as well to
> use the fifo size from device tree. Otherwise, it will get from the
> static array in 8250.c.

No, it's the other way around. It is picked from the array
conditionally, only in case it was not already set. However, if
UPF_FIXED_TYPE is removed then autoconfig() will override it.

Thanks,

-- 
heikki
