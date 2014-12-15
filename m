Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaLOMxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:53:11 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42224 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLOMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:53:09 -0500
Date: Mon, 15 Dec 2014 04:53:05 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Message-ID: <20141215125305.GA18251@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
 <20141215102321.GD6778@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215102321.GD6778@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan,

On Mon, Dec 15, 2014 at 11:23:21AM +0100, Johan Hovold wrote:
> On Thu, Dec 11, 2014 at 03:29:52PM -0800, Jeremiah Mahler wrote:
> > If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
> > unplugged, a bunch of -ENODEV and -EPROTO errors will be produced in the
> > logs.  This patch set quiets these messages without changing the
> > original behavior.
> 
> Don't unplug devices that are in use then. ;)
> 
I knew someone was going to say that :-)

> > This change is beneficial when using daemons such as slcand, which is
> > similar to pppd or slip, that cannot determine whether they should exit
> > until after the USB serial device is unplugged.  Producing these error
> > messages for a normal use case is not helpful.
> 
> Your patches would hide these errors when they occur during normal use
> (e.g. EPROTO).
> 
> Receiving an error message when unplugging an active device should not
> surprise anyone. And at least you know where it came from (and it's
> right there in the logs as well).
> 
> Johan

Hmm.  Yes, I can see why quieting -EPROTO would be bad because it would
hide protocol errors which we want to know about.

I need to re-think this patch.
Nack.

Thanks for the review,
-- 
- Jeremiah Mahler
