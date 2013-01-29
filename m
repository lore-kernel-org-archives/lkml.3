Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab3A2PQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:16:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:47941 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3A2PQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:16:28 -0500
Date: Tue, 29 Jan 2013 07:18:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, shurd@broadcom.com, mchan@broadcom.com
Subject: Re: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Message-ID: <20130129151818.GA2976@kroah.com>
References: <1358460893-11098-1-git-send-email-mchan@broadcom.com>
 <87ip6gm3kf.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip6gm3kf.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:06:24PM +0200, Alexander Shishkin wrote:
> Michael Chan <mchan@broadcom.com> writes:
> 
> > From: Stephen Hurd <shurd@broadcom.com>
> >
> > Add support for the UART device present in Broadcom TruManage capable
> > NetXtreme chips (ie: 5761m 5762, and 5725).
> >
> > This implementation has a hidden transmit FIFO, so running in single-byte
> > interrupt mode results in too many interrupts.  The UART_CAP_HFIFO
> > capability was added to track this.  It continues to reload the THR as long
> > as the THRE and TSRE bits are set in the LSR up to a specified limit (1024
> > is used here).
> >
> > Signed-off-by: Stephen Hurd <shurd@broadcom.com>
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> 
> Greg, this looks like a new feature, yet it was applied to -rc5 and
> stable. Any reason for that? I'm asking because this patch doesn't seem
> to have received enough reviewing/testing:
> 
> [skip platform bits]
> 
> > diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> > index 78f99d9..2c6c85f 100644
> > --- a/include/uapi/linux/serial_core.h
> > +++ b/include/uapi/linux/serial_core.h
> > @@ -50,7 +50,8 @@
> >  #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
> >  #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
> >  #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
> > -#define PORT_MAX_8250	24	/* max port ID */
> > +#define PORT_BRCM_TRUMANAGE	24
> > +#define PORT_MAX_8250	25	/* max port ID */
> 
> This is a bug, TRUMANAGE should be 25 as well as PORT_MAX_8250.

Good catch, care to make up a patch to fix it?

thanks,

greg k-h
