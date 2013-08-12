Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3HLRcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:32:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3HLRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:32:20 -0400
Date: Mon, 12 Aug 2013 10:32:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matt Burtch <matt@grid-net.com>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB-Serial: Fix error handling of usb_wwan
Message-ID: <20130812173218.GA9476@kroah.com>
References: <1376327499-528-1-git-send-email-matt@grid-net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376327499-528-1-git-send-email-matt@grid-net.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:11:39AM -0700, Matt Burtch wrote:
> This fixes an issue where the bulk-in urb used for incoming data transfer
> is not resubmitted if the packet recieved contains an error status.  This
> results in the driver locking until the port is closed and re-opened.
> 
> Tested on a custom board with a Cinterion GSM module.
> 
> Signed-off-by: Matt Burtch <matt@grid-net.com>

Ah, nice catch, thanks for this, I'll also mark it for the stable tree
as it's something that those kernels would want to pick up.

greg k-h
