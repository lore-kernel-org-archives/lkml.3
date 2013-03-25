Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3CYImh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:42:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:7721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab3CYIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:42:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="284124712"
Date: Mon, 25 Mar 2013 10:42:30 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCHv2 2/2] serial: of_serial: Handle fifo-size property
Message-ID: <20130325084230.GA20052@xps8300>
References: <20130322074154.GA9250@xps8300>
 <1363939516-17308-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1363940208.2289.22.camel@leyfoon-vm>
 <20130322092421.GA3134@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322092421.GA3134@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 22, 2013 at 11:24:21AM +0200, Heikki Krogerus wrote:
> On Fri, Mar 22, 2013 at 04:16:48PM +0800, Ley Foon Tan wrote:
> > Besides the fifo size, we need to have hardware flow control setting
> > from device tree as well.
> 
> This is a bit problematic. We can set the uart_8250_port.capabilities
> flag UART_CAP_AFE based on "hw-flow-control" property, but then the
> properties from the type will not be used, just like in case of
> fifosize. We would need to know all the flags of the type that are
> normally taken from the uart_config[] array.
> 
> The UART_CAP_FIFO can be set by checking if we have set the
> port.fifosize or not, so if the bellow is acceptable then I can make a
> patch. There is no risk of overriding the capabilities for the
> existing uarts, as we only touch the uart_8250_port.capabilities if
> the new properties are used. So is it OK?

I'll resend these two patches and add the support for hardware flow
control.

-- 
heikki
