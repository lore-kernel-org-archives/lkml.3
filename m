Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3KVRBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:01:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:46237 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3KVRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:01:41 -0500
Message-ID: <528F8DF1.2060307@linutronix.de>
Date: Fri, 22 Nov 2013 18:01:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Jackson <mpfj-list@newflow.co.uk>
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        jkosina@suse.cz, anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Bin Liu <binmlist@gmail.com>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
References: <528F7E8F.5050807@newflow.co.uk> <528F8741.1060406@linutronix.de> <528F8B35.8070408@newflow.co.uk>
In-Reply-To: <528F8B35.8070408@newflow.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:49 PM, Mark Jackson wrote:
>> and the ID pin not on ground or 3.3V?
>> What are the side effects? I remember correctly Bin wanted to avoid
>> settings this if it could be avoided.
> 
> Yes ... we have a host only USB port and an unconnected ID pin.

Is it too late to connect that pin?

> AFAIK it defaults to device mode so I can't see any devices that get
> plugged into the USB port.
> 
> If I tweak the s/w to "force" host mode on, then everything appears to
> work okay.
> 
> I guess it's more of a hardware oversight that we left the pin floating
> but in the real world, I guess someone may want this feature to they
> can change the usb port type ?

This is something I would prefer to avoid if possible. We have the
dr_mode attribute in DT. Based on that one we act as a device or host.
Now if you decide (via dr_mode) either for host or device that means we
have to set that bit. Where I feel a little uncomfortable is when
someone having OTG runs in hostmode and attaches a host.

> 
> Either way, I need to fix the current h/w (which can be done via s/w)
> hence the patch.
I've seen many projects where this pin has been forgotten and it could
not be changed in SW and they patched the HW. Usually this is noticed
in the early phase and a wire is just soldered and the redesign has it
fixed. So I don't think that this is a big issue.
Do you insists on having this change merged upstream?

> 
> Mark J.
> 

Sebastian
