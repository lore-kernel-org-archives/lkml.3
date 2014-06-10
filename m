Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaFJLB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:01:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59654 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaFJLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:01:55 -0400
Date: Tue, 10 Jun 2014 12:01:36 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
Message-ID: <20140610120136.2c2cb881@alan.etchedpixels.co.uk>
In-Reply-To: <53965D53.3010107@hurleysoftware.com>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
	<1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
	<20140609140823.6013838d@alan.etchedpixels.co.uk>
	<53965D53.3010107@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch only affects the line state if the last tty reference is closed
> or the tty is hung up by software (like on controlling process exit).
> In this case, any login session is already dying, and it would not be possible
> to hijack a live session. A successful re-login is still required.

It breaks the other direction - yes sorry.
 
> Notwithstanding what I wrote above, this patch does change behavior
> with remote consoles, which may be unacceptable.
 
> For example, if the remote user logs out, the current behavior hangs up
> the modem (if HUPCL), whereas the patch behavior just presents a new
> login prompt.

which means the modem will probably no longer answer calls.

> So yeah, I agree; this patch should be dropped.

Possibly we should also fix this the other way in tty_port_shutdown,
which does wrongly skip dtr/rts handling of consoles.

As far as I can see providing HUPCL is clear the desired console
behaviour for most situations with a remote console link is obtained.

Alan
