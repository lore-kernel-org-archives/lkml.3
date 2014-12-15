Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaLOJwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:52:46 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:56445 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:52:42 -0500
Date: Mon, 15 Dec 2014 10:52:38 +0100
From: Johan Hovold <johan@kernel.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
Message-ID: <20141215095238.GB6778@localhost>
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
 <20141210130412.GJ14346@localhost>
 <CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
 <CAFSKS=MH0CU=t-TyHgcOun050EBQawkaDXfSN2OoC6MpZKgjmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=MH0CU=t-TyHgcOun050EBQawkaDXfSN2OoC6MpZKgjmw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:51:11AM -0600, George McCollister wrote:
> Johan,
> 
> While working on the tx_empty changes you suggested it occurred to me
> that it might not be obvious to others that the firmware doesn't send
> a packet with the NT124_CTRL_TXEMPTY flag cleared when it begins
> transmitting. The practical implication is that if the driver sets
> tx_empty = true when it sees NT124_CTRL_TXEMPTY, tx_empty must be
> reset to false somewhere when more data is transmitted. Perhaps I
> could add prepare_write_buffer and do it in there before calling
> usb_serial_generic_prepare_write_buffer(). Does that sound acceptable?

Hmm. There's no way to query that flag? And the status is sent (as bulk
in data) periodically or only when data has been received? And not when
the actual status changes?

A potential problem with using prepare_write_buffer would be on failures
to submit the write urb, in which case this flag might never be cleared.

Johan
