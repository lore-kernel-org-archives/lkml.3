Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaBTVkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:40:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBTVkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:40:21 -0500
Date: Thu, 20 Feb 2014 13:41:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 3.12 037/107] spidev: fix hang when transfer_one_message
 fails
Message-ID: <20140220214147.GA25193@kroah.com>
References: <20140211184748.191276235@linuxfoundation.org>
 <20140211184749.254574462@linuxfoundation.org>
 <CAMuHMdWVRTPSeVEAPTM7KLME4db0vfBYuH6N7pNoUwNPb0aZ7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWVRTPSeVEAPTM7KLME4db0vfBYuH6N7pNoUwNPb0aZ7w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:42:08PM +0100, Geert Uytterhoeven wrote:
> On Tue, Feb 11, 2014 at 8:05 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> Sorry for not noticing this was queued up for stable before, but this
> patch was reverted in mainline:
> 
> commit 1f802f8249a0da536877842c43c7204064c4de8b
> Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Date:   Tue Jan 28 10:33:03 2014 +0100
> 
>     spi: Fix crash with double message finalisation on error handling
> 
>     This reverts commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d.
> 
>     It causes a NULL pointer dereference with drivers using the generic
>     spi_transfer_one_message(), which always calls
>     spi_finalize_current_message(), which zeroes master->cur_msg.
> 
>     Drivers implementing transfer_one_message() theirselves must always call
>     spi_finalize_current_message(), even if the transfer failed:
> 
>      * @transfer_one_message: the subsystem calls the driver to transfer a singl
>      *      message while queuing transfers that arrive in the meantime. When th
>      *      driver is finished with this message, it must call
>      *      spi_finalize_current_message() so the subsystem can issue the next
>      *      transfer
> 
>     Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>     Signed-off-by: Mark Brown <broonie@linaro.org>

Thanks for catching this, I've queued it up now.

greg k-h
