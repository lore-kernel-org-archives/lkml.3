Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaECRip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 13:38:45 -0400
Received: from mout.gmx.net ([212.227.17.22]:65260 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaECRim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 13:38:42 -0400
MIME-Version: 1.0
Message-ID: <trinity-96c5af7b-0fcf-4dc9-bfd9-f6d9d79a8938-1399138714679@msvc018>
From: tbilles@gmx.com
To: "Hans de Goede" <hdegoede@redhat.com>, "Zhang Rui" <rui.zhang@intel.com>,
        "Len Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Aaron Lu" <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Possible regression: sluggish inputs
Content-Type: text/plain; charset=UTF-8
Importance: normal
Date: Sat, 3 May 2014 19:38:34 +0200
X-Priority: 3
X-Provags-ID: V03:K0:0YFomjvYu2rBFI061ynl//neHqL8d5cCQk9I7/N4n2r
 7Oj05KnC1+Tu1nOAi2UFnDUoTF0IJxDOb7JcM+7d2chWZKliDk
 Bcy0Af+x9PFz/ok29DZ7vTH0bTA7giNekKUwRWPhn+HopJf3Ty
 0ad0cg1rDYoskNOnvR56QMs15a0XfTpb6EwP5XzQN44AB8YoPX
 SHZnAl+cerQSaa7Gtoi1PMRB0cNBe3Bc2DMm/O4PmgWDhiKnv5
 pX2W4YOM6Sq2A5e4Z7xcXVpEkHfTeyOaK0bAXu7MJs3viYoRZs YAxhuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 03 May 2014 at 10:00:38, Hans de Goede wrote:

> On 05/02/2014 07:03 PM, Tibor Billes wrote:
>
> > Hi,
> >
> > I've upgraded my 3.13.5 kernel to 3.14.2 and I noticed that
> > sometimes my mouse is slow to react. By slow I mean the pointer on
> > the screen doesn't follow its path smoothly, instead it jumps from
> > one position to the next at only a few jumps per second rate. Like
> > if the kernel could only process 2 or 3 position updates per second
> > from the mouse. (As far as I can tell, the machine is in idle.)
> > After experimenting a little I found out that the keyboard is also
> > affected. Keystrokes are delayed, letters appearing in bursts. This
> > behaviour (for both the mouse and the keyboard) lasts only for a
> > couple of seconds, then it suddenly goes away and everything works
> > as expected. I also noticed that this behaviour shows up after I
> > haven't touched the mouse or the keyboard for short time (around 10
> > seconds, but I didn't measure this).
> 
>
> What I think is happening is that you've auto screen dimming on
> inactivity enabled in your desktop environment settings, which results
> in trying to change the backlight after 10 seconds of inactivity. Then
> the intel video driver likely directly writes to
> /sys/class/backlight/acpi_video0/brightness and gets stuck in that
> write because the acpi code gets stuck.

Did you figure out why the acpi code gets stuck? Sounds like it
shouldn't do that :) I'm not a kernel developer so I can't do much about
it, I'm just curious.

> I've seen this happen occasionally on my E6430 both with and without
> the patch the bisect points too. I can trigger it by pressing
> brightness up / down as fast as I can. Likely the dimming on
> inactivity code is doing a much better job at sending brightness
> change commands as fast as possible, making it easier to trigger this.
> As for the commit you've bisected it too, it may be that that subtly
> changes things to make the problem easier to trigger, 

I don't have auto screen dimming enabled, but there could be something
else triggering it. Other than this, it all makes sense. The brightness
up / down buttons always act slowly for me. I can too trigger the sluggish
behaviour by pressing the brightness up or down buttons fast and
simultaneously moving the mouse. So yes, your patch is not the cause
of this, but for some reason it makes it easier to trigger. 

> but I distinctly remember having the same issue before I wrote that
> patch.

Let me try this 'your patch reverted on top of 3.14.2' kernel for a few
days to see if this behaviour shows up. Maybe I had it too, I just
didn't notice, because it was less frequent.

> Have you tried updating your BIOS ?

No, I haven't. Have you tried it? Did it help? I'm reluctant to upgrade
my BIOS, I've never done this before. I'm afraid I do something wrong
and I end up with comupter that is unable to boot.

Regards,
Tibor
