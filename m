Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaAMWzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:55:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaAMWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:55:29 -0500
Date: Mon, 13 Jan 2014 14:56:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1] driver core/platform: don't leak memory allocated for
 dma_mask
Message-ID: <20140113225606.GA4132@kroah.com>
References: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
 <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:38:05PM +0100, Yann Droneaud wrote:
> If a dma_mask is provided as part of platform_device_info,
> platform_device_register_full() allocate memory for a u64
> using kmalloc().
> 
> A comment in the code state that "[t]his memory isn't freed
> when the device is put".
> 
> It's never a good thing to leak memory, but there's only very
> few users of platform_device_info's dma_mask, and those are mostly
> "static" devices that are not going to be plugged/unplugged.

Why haven't you cc:ed the author of that comment?  He would be best to
evaluate if this patch is good enough or not.

And is leaking that memory really an issue?  As you point out, these
aren't devices that are going to go away (I'd argue that no platform
device should ever be a removable device, but that's a longer
argument...)

Please resend and cc: all of the needed developers.

thanks,

greg k-h
