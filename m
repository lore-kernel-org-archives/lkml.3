Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3LEEbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:31:43 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:35360 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LEEbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:31:41 -0500
Message-ID: <1386217896.7152.8.camel@host5.omatika.ru>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
From: Sergei Ianovich <ynvich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Date: Thu, 05 Dec 2013 08:31:36 +0400
In-Reply-To: <20131205041251.GA24906@kroah.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
	 <20131202090253.GE3942@xps8300> <1385976238.12531.8.camel@host5.omatika.ru>
	 <20131202094932.GF3942@xps8300>
	 <1385980005.12531.21.camel@host5.omatika.ru>
	 <20131202141033.GK3942@xps8300> <20131205041251.GA24906@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 20:12 -0800, Greg Kroah-Hartman wrote:
> On Mon, Dec 02, 2013 at 04:10:33PM +0200, Heikki Krogerus wrote:
> > On Mon, Dec 02, 2013 at 02:26:45PM +0400, Sergei Ianovich wrote:
> > > Who makes the decision which way to go?
> > 
> > Greg and Russel make this decision. By having the pxa driver simply
> > register 8250 ports would probable reduce the code. Thats about the
> > biggest benefit from it.
> > 
> > It would still be something nice to have IMO. Ideally all the
> > 8250/16x50 UARTs should register the ports with 8250_core.c, and not
> > create complete uart driver on their own.
> 
> I agree, this is the best way to resolve this, having a separate uart
> driver isn't that good at all to be doing, if at all possible.

I'm reading the last message as a confirmation that
drivers/tty/serial/pxa.c needs to be rewritten using 8250_core.c.
However, "if at all possible" confuses me, since we have pxa.c in the
tree and it works. Greg, could you please clarify?

