Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbaFINIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:08:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58327 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaFINIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:08:40 -0400
Date: Mon, 9 Jun 2014 14:08:23 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
Message-ID: <20140609140823.6013838d@alan.etchedpixels.co.uk>
In-Reply-To: <1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
	<1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jun 2014 10:16:10 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> If a tty is opened on a serial console, don't drop DTR on
> last tty close, on tty hangup, or when resetting port hardware
> via TIOCSSERIAL and TIOCSERCONFIG ioctls.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

NAK

This introduces a security flaw.

If you have a system with a remote console you dial into then with this
patch applied a modem drop eg from a bad line will no longer drop any
live session and ensure a login is required as it was before.

That's a pretty bad regression case.

If you are running a serial console and want to leave DTR high either
wire the cable that way or don't set HUPCL in the first place. The
technology for fixing this problem already exists!

Alan
