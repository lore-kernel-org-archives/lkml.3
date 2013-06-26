Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FZDQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:16:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:3560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3FZDQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="355818534"
Message-ID: <1372216578.8177.9.camel@envy.home>
Subject: Re: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Date: Tue, 25 Jun 2013 20:16:18 -0700
In-Reply-To: <20130626023143.GB23320@kroah.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>
	 <20130626023143.GB23320@kroah.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 19:31 -0700, Greg Kroah-Hartman wrote:
> On Tue, Jun 25, 2013 at 06:53:22PM -0700, Darren Hart wrote:
>   
> >  struct pch_uart_buffer {
> >  	unsigned char *buf;
> > @@ -398,6 +399,10 @@ static int pch_uart_get_uartclk(void)
> >  		    strstr(cmp, "nanoETXexpress-TT")))
> >  		return NTC1_UARTCLK;
> >  
> > +	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> > +	if (cmp && strstr(cmp, "MinnowBoard"))
> > +		return MINNOW_UARTCLK;
> > +
> 
> You know, we do have the DMI interface to handle this in a much nicer
> way instead of just randomly trying different strings over and over
> until we find one that matches...

I was aiming for minimal change. Partly because I'm lazy. Partly
because I don't have all of the impacted hardware to test. Partly
because I wanted to keep it simple so I could push this to 3.8 stable.

I can rewrite this detection to use the DMI interface. Would you allow
it as a follow-on, to keep the changes to stable minimal?

Also, I do have a PCI subsystem ID for this particular board which I
could trigger on, but since that mechanism didn't exist in the driver
already and the other boards don't do it, I just followed what was
already there (yeah, so I wrote most of what was already there...
but.... anyway) :-)

What do you prefer? Rewrite, then add Minnow, or use this, then
rewrite?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

