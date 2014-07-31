Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaGaQIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:08:18 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:44098 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGaQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140731151941.244fd508@alan.etchedpixels.co.uk>
References: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
 <1406651242-20689-2-git-send-email-ricardo.ribalda@gmail.com> <20140731151941.244fd508@alan.etchedpixels.co.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 31 Jul 2014 18:07:55 +0200
Message-ID: <CAPybu_1Ma+7nGaS0e17HpPcM1vk6ANSFN3C8MNR=JxWrBBmMOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] serial: Add support for Fintek F81216A LPC to 4 UART
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

> Less than ideal in some ways because the base may well be remapped by
> other hardware or on non x86 devices. No obvious ideas how to fix it
> though and PnP kind of implies x86.

If I extend the driver to consider other hw than x86 and PnP I will
definitely  look into this.

>
> On the bright side you can then make the resource layer do your locking
> work for you. We have an IORESOURCE_MUXED flag for these little horrors
> so you can request the resource with IORESOURCE_MUXED. If the resource is
> busy then you will get a failure back, if it is idle you will get the
> resource, if it is busy but held by another driver using IORESOURCE_MUXED
> then the request will block until they finish with it.

I was not aware of request_mutex, thanks for your help!. I am
preparing v2 with no mutex and requtest_mutex_region.

Thanks!

-- 
Ricardo Ribalda
