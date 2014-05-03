Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaECIbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 04:31:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaECIbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 04:31:02 -0400
Message-ID: <5364A226.4040900@redhat.com>
Date: Sat, 03 May 2014 10:00:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tibor Billes <tbilles@gmx.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Aaron Lu <aaron.lu@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Possible regression: sluggish inputs
References: <trinity-3958d3e8-f087-4d8d-b313-b1318b5f54f9-1399050238997@msvc011>
In-Reply-To: <trinity-3958d3e8-f087-4d8d-b313-b1318b5f54f9-1399050238997@msvc011>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/02/2014 07:03 PM, Tibor Billes wrote:
> Hi,
> 
> I've upgraded my 3.13.5 kernel to 3.14.2 and I noticed that sometimes my mouse is slow to react.
> By slow I mean the pointer on the screen doesn't follow its path smoothly, instead it jumps from one
> position to the next at only a few jumps per second rate. Like if the kernel could only process 2 or 3
> position updates per second from the mouse. (As far as I can tell, the machine is in idle.)
> After experimenting a little I found out that the keyboard is also affected. Keystrokes are delayed,
> letters appearing in bursts. This behaviour (for both the mouse and the keyboard) lasts only for a
> couple of seconds, then it suddenly goes away and everything works as expected. I also noticed that
> this behaviour shows up after I haven't touched the mouse or the keyboard for short time (around
> 10 seconds, but I didn't measure this).

What I think is happening is that you've auto screen dimming on inactivity enabled in your
desktop environment settings, which results in trying to change the backlight after 10 seconds
of inactivity. Then the intel video driver likely directly writes to
/sys/class/backlight/acpi_video0/brightness and gets stuck in that write because the acpi code
gets stuck.

I've seen this happen occasionally on my E6430 both with and without the patch the bisect
points too. I can trigger it by pressing brightness up / down as fast as I can. Likely the
dimming on inactivity code is doing a much better job at sending brightness change commands
as fast as possible, making it easier to trigger this.

As for the commit you've bisected it too, it may be that that subtly changes things to make
the problem easier to trigger, but I distinctly remember having the same issue before I wrote
that patch.

Have you tried updating your BIOS ?

Regards,

Hans
