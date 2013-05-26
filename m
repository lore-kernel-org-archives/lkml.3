Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3EZW5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:57:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3EZW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:57:43 -0400
Date: Mon, 27 May 2013 07:57:57 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: How to get driver_data of struct ieee1394_device_id in kernel
 driver module?
Message-ID: <20130526225757.GA32606@kroah.com>
References: <51A20AEE.7060201@sakamocchi.jp>
 <20130526233513.1a95d0d5@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130526233513.1a95d0d5@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:35:13PM +0200, Stefan Richter wrote:
> I think your approach is sensible.  There is of course just the little
> problem that firewire-core keeps the matching device_id table entry as a
> secret to itself.  Therefore, struct ieee1394_device_id.driver_data is
> currently totally useless.
> 
> How about we make it available like in the following patch?
> 
> Besides being useful to your presently out-of-tree work, the in-tree
> sound/firewire/speakers.c::fwspk_detect() could be rewritten to use this
> approach.  Maybe I will post an expanded version of this patch which
> incorporates such a first in-tree usage.

Why not pass it in the probe() function, like USB and PCI does?  That
way, if the driver wants to save it for that device, it can.

thanks,

greg k-h
