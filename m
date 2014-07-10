Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaGJXKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:10:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaGJXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:10:05 -0400
Date: Thu, 10 Jul 2014 16:14:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Seth Bollinger <sethb@digi.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 0/2] fixes for empty tx buffer breakage
Message-ID: <20140710231432.GA9423@kroah.com>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
 <1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 11:29:51AM -0400, Peter Hurley wrote:
> Cc: Seth Bollinger <sethb@digi.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> 
> Greg,
> 
> I completed the audit of serial drivers after reports that
> several Sun serial drivers were broken by
> commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
> 'serial_core: Fix conditional start_tx on ring buffer not empty'.
> 
> I apologize for not submitting this sooner. The delay was due to
> an ongoing analysis of serial flow control prompted by Sam Ravnborg's
> question:
> 
> On 06/10/2014 03:24 PM, Sam Ravnborg wrote:
> > I also noticed the typical pattern is:
> > 
> >      if (uart_circ_empty(xmit) || uart_tx_stopped(port))
> > 
> > Should you use this pattern also in sunsab.c?
> 
> Unfortunately, that analysis revealed that tx flow control is
> largely SMP-unsafe, and it's fairly easy to corrupt the hardware
> state wrt. the tty flow control state.
> 
> I'm still working on the solutions to that; they're too
> extensive to submit for 3.16 anyway.

So these should go into 3.16-final?  Or 3.17?

confused,

greg k-h
