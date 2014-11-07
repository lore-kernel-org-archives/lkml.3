Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKGJT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:19:27 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:37638 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:19:23 -0500
Date: Fri, 7 Nov 2014 10:16:15 +0100
From: Johan Hovold <johan@kernel.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nix <nix@esperi.org.uk>,
        Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: cdc-acm: add quirk for control-line state requests
Message-ID: <20141107091615.GC27326@localhost>
References: <20141106170456.GC26196@localhost>
 <1415293713-3051-1-git-send-email-johan@kernel.org>
 <1415351112.2671.9.camel@linux-0dmf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415351112.2671.9.camel@linux-0dmf.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:05:12AM +0100, Oliver Neukum wrote:
> On Thu, 2014-11-06 at 18:08 +0100, Johan Hovold wrote:
> > Add new quirk for devices that cannot handle control-line state
> > requests.
> > 
> > Note that we currently send these requests to all devices, regardless
> > of
> > whether they claim to support it, but that errors are only logged if
> > support is claimed.
> 
> That makes me wonder whether we should do this. What do you think?

My interpretation was that it's done this way as there may be devices
with broken CDC headers which fail to set the corresponding capability
bits, but still support the request (c.f. our recent not-a-modem
discussion).

In that case, always attempting the request, but only reporting errors
if support was claimed, makes sense.

As changing this behaviour now would risk breaking such devices, I
think black-listing (i.e. this patch) is preferred moving forward.

Johan
