Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3BKQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:12:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab3BKQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:12:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O routines
Date: Mon, 11 Feb 2013 17:12:48 +0100
Message-ID: <1684430.yK4oBgpgAE@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-4-generic; KDE/4.10.0; x86_64; ; )
In-Reply-To: <20130211154812.GU20996@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <201302111508.24317.arnd@arndb.de> <20130211154812.GU20996@sortiz-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2GhC95+BWJ47dJhGEtXsIJWBJZK+P4l5zXOwY++x2dR
 mvivM3ax1u5yq4c/seCnT+QdxYwpAUUR0jz4KsRNcBfmoympoy
 RhOt/7vesTVLggRXraWhDvK/heNXaBCRe8tpuPCpzxx7smKBWC
 Y33C8XYD4RaCckdzBMqySN11VEcaNacwBKFlEfzvf71J338gLu
 IU89XPrYBViwiLl3w2lQxQJNe+gqsor0gntiAvuTMs+K4CrNFm
 0k9zTORQryGauBrRw778NPSqhnTPCqVNa3q2z0CHnCS4TmwolJ
 DAy5rKfvTa+RXjfkT76exNUFmCHn60Rb1Q7ZuUDFz0rTZIIRNh
 VJVpB0eUM0Sy114I8O8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 16:48:12 Samuel Ortiz wrote:
> 
> > If so, how do you know which transport to use?
> Through the mei_bus_client ops. Device drivers get a mei_bus_client pointer
> from their probe routine and the ops pointers there (If any) are set by
> whoever creates the device. In the NFC case mei/nfc.c does that and implements
> the NFC specific transport code for this technology. mei/nfc.c is also the
> part of the code that actually adds the device to the bus.

Ok.

> So when a device driver wants e.g. to send its payload through the MEI bus, it
> calls mei_bus_send() which takes the device driver mei_bus client pointer as
> its first argument.
> Then the payload may go through mei_bus_client->send() first which will eventually
> physically sent the newly built frame through mei_send(). Some ME blocks don't require any
> additional transport layer and in that case the device driver payload will go
> straight to mei_send() since the mei_bus_client ops will be NULL.
> 
> Does that make more sense now ?

Yes, so it's not actually as complicated as I thought, because
the operations are already known by the bus driver (in the
normal sense of that word, meaning the driver that creates
the device not the one driving it) at the time when the device is
created.

In that case, please ignore my original comment and put the
struct mei_bus_ops (mei_transport_ops?) back, ideally as a
"const" member of the struct mei_bus_device (to be called
mei_device then), so you can declare the structure statically
and constant in the driver that has the functions.

	Arnd
