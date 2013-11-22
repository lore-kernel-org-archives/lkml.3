Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3KVQuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:50:00 -0500
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:43643
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752565Ab3KVQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:49:58 -0500
Message-ID: <528F8B35.8070408@newflow.co.uk>
Date: Fri, 22 Nov 2013 16:49:57 +0000
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        jkosina@suse.cz, anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Bin Liu <binmlist@gmail.com>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
References: <528F7E8F.5050807@newflow.co.uk> <528F8741.1060406@linutronix.de>
In-Reply-To: <528F8741.1060406@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/13 16:33, Sebastian Andrzej Siewior wrote:
> On 11/22/2013 04:55 PM, Mark Jackson wrote:
>> The IDDIG input pin is normally used to determine the USB mode
>> (i.e. HOST or DEVICE).
>>
>> On some systems (e.g. AM335x) leaving this pin floating allows
>> the USB mode to be set via software.
> 
> So you have a board where musb is used only as host or only as device
> and the ID pin not on ground or 3.3V?
> What are the side effects? I remember correctly Bin wanted to avoid
> settings this if it could be avoided.

Yes ... we have a host only USB port and an unconnected ID pin.

AFAIK it defaults to device mode so I can't see any devices that get
plugged into the USB port.

If I tweak the s/w to "force" host mode on, then everything appears to
work okay.

I guess it's more of a hardware oversight that we left the pin floating
but in the real world, I guess someone may want this feature to they
can change the usb port type ?

Either way, I need to fix the current h/w (which can be done via s/w)
hence the patch.

Mark J.

