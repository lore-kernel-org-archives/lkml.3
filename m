Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaKKF2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:28:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaKKF2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:28:39 -0500
Date: Tue, 11 Nov 2014 14:27:20 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jingchang Lu <jingchang.lu@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [RESENDv5] serial: of-serial: fix up PM ops on
 no_console_suspend and port type
Message-ID: <20141111052720.GC24727@kroah.com>
References: <1414401857-21121-1-git-send-email-jingchang.lu@freescale.com>
 <CAGVrzcamoYbdPijWtrU=ge+UE+g9zBHAG84PJB7G3EyA09jBWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcamoYbdPijWtrU=ge+UE+g9zBHAG84PJB7G3EyA09jBWg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:30:36PM -0800, Florian Fainelli wrote:
> 2014-10-27 2:24 GMT-07:00 Jingchang Lu <jingchang.lu@freescale.com>:
> > This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
> > "serial: of-serial: add PM suspend/resume support", which disables
> > the uart clock on suspend, but also causes a hardware hang on register
> > access if no_console_suspend command line option is used.
> >
> > Also, not every of_serial device is an 8250 port, so the serial8250
> > suspend/resume functions should only be applied to a real 8250 port.
> 
> Greg, can you pick this one and submit it for your next 3.18-rc
> submission? This fixes a regression when using "no_console_suspend"
> introduced by:
> 
> 2dea53bf57783f243c892e99c10c6921e956aa7e ("serial: of-serial: add PM
> suspend/resume support") which has been merged during 3.18-rc1

Why can't I just revert that patch instead?  This is really late in the
-rc cycle to be doing large fixes like this.

And this patch is already queued up for 3.19-rc1, so this is a mess...

Any objection to me just reverting
2dea53bf57783f243c892e99c10c6921e956aa7e, and then this one in my
tty-next branch as well, and then someone resending the original patch
in a format that actually works?

thanks,

greg k-h
