Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaGGNVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:21:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35838 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaGGNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:21:41 -0400
Date: Mon, 7 Jul 2014 14:20:56 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
Message-ID: <20140707142056.46f61cf9@alan.etchedpixels.co.uk>
In-Reply-To: <1404491651-1388-3-git-send-email-bigeasy@linutronix.de>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
	<1404491651-1388-3-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 18:34:10 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> While comparing the OMAP-serial and the 8250 part of this I noticed that
> the the latter does not use runtime-pm.

Yes it does, but 8250 parts (generally - omap presumably is special
here ?) need to be powered on to transmit/receive not just for register
access. The core uart layer implements a "pm" operation for this.

As 8250_dw uses runtime pm to implement the pm operation it's not as
simple as assumign it won't get triggered.

I *think* this is ok because the designware and other cases would take a
reference on open and drop it on close, so avoiding any confusion, but
for the register accesses on a closed port it would benefit from a
further double check with Mika especially as the suspend/resume on the
LPSS block on some Intel devices is a little bit too "interesting" for
comfort.

Otherwise however I think this is good.

Alan


