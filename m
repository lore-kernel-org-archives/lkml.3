Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaLOKX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:23:28 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:44651 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaLOKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:23:25 -0500
Date: Mon, 15 Dec 2014 11:23:21 +0100
From: Johan Hovold <johan@kernel.org>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Message-ID: <20141215102321.GD6778@localhost>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 03:29:52PM -0800, Jeremiah Mahler wrote:
> If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
> unplugged, a bunch of -ENODEV and -EPROTO errors will be produced in the
> logs.  This patch set quiets these messages without changing the
> original behavior.

Don't unplug devices that are in use then. ;)

> This change is beneficial when using daemons such as slcand, which is
> similar to pppd or slip, that cannot determine whether they should exit
> until after the USB serial device is unplugged.  Producing these error
> messages for a normal use case is not helpful.

Your patches would hide these errors when they occur during normal use
(e.g. EPROTO).

Receiving an error message when unplugging an active device should not
surprise anyone. And at least you know where it came from (and it's
right there in the logs as well).

Johan
