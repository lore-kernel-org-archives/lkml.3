Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab3GWSzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:55:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49454 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab3GWSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <51EEBE05.2040000@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
	<CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
	<51EEBE05.2040000@linutronix.de>
Date: Tue, 23 Jul 2013 13:55:27 -0500
Message-ID: <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Jul 23, 2013 at 12:31 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 07/23/2013 07:28 PM, Bin Liu wrote:
> > Hi,
>
> Hi,
>
> >
> > On Mon, Jul 22, 2013 at 1:10 PM, Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de <mailto:bigeasy@linutronix.de>> wrote:
> >
> >     This patch adds the MUSB_DEVCTL_SESSION back after it has been removed.
> >     If it is missing then the host session is not recognized. This bit is
> >     added initially added in musb_start() and removed after the first device
> >     disconnect.
> >
> > AFAIK, after the device is  disconnected, the OTG state machine will go
> > back to B_IDLE/A_IDLE state. SESSION is not needed in this case.
>
>
> Okay.
>
> > In OTG mode, when no device is plugged, the ID pin is floating, you can
> > never hold the host session in this case, even set the SESSION bit. The
> > SESSION bit will be cleared by the controller after 100ms.
>
> In my testing the bit remains set. How is the bit supposed to come back
> after I connect a host device?
The bit remains even when no device is plugged and ID ping is float?
what platform do you use to test it?

'a host device'? you meant a usb device? By the otg specs, the session
will not automatically start. The user/app has to issue the command,
either by SRP or HNP, or something else. In TI 3.2 kernel, there is
workaround in otg_timer() to _toggle_ the SESSION bit to detect if ID
pin is grounded, which means a USB device is connected.

Regards,
-Bin.

>
> > Regards,
> > -Bin.
> >
>
> Sebastian
