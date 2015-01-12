Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbbALAgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:36:22 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:50880 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbALAgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150111225802.GA12944@node.dhcp.inet.fi>
References: <20141218175126.GA78864@vmdeb7> <20150111225802.GA12944@node.dhcp.inet.fi>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 11 Jan 2015 16:36:00 -0800
X-Google-Sender-Auth: guh4k0VEPIH_MpAfW2zffgTCnIM
Message-ID: <CAObL_7GDCn22+r+zAdH=hCt3or2vk5S=CR8oRqpu1y30r54hTA@mail.gmail.com>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Darren Hart <dvhart@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 2:58 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
>> thinkpad-acpi using software mute simplifies the driver and the user experience
>> significantly.
>
> Except when it doesn't.
>
> I'm probably in minority, but I don't use fancy userspace to mess with my
> mixer and the mute button worked just fine for me before the change.
> Wasted half an hour to find out what happened is not a pure win from user
> experience point of view.
>
> Is it really necessary to have software_mute_requested == true by default?
> Can fancy userspace ask for desired behaviour instead and change kernel to
> not send hotkeys change notification until software_mute is enabled?

The problem is that fancy userspace (which isn't really very fancy,
nor does it need to be new) expects KEY_MUTE to be a normal keypress.
It turns out to be a normal keypress on every single computer in
existence AFAICT except ThinkPads.  As a result, any remotely portable
user program that handled volume hotkeys got confused on ThinkPads.

I think the real solution is to have some little daemon that handles
KEY_MUTE and changes the ALSA state if that's the behavior you want.
Having the EC change the sound output *without* changing the ALSA
state or even giving a notification (the pre-3.19 behavior) really
doesn't seem like a sensible default to me.

(It may be that on newer pre-3.19 kernels, it wasn't quite as bad as
it was on much older kernels, since the ALSA hack that tries to
control the mute LED seems to feed back into the EC control of the
hardware mute switch, so at least the light would stay in sync with
everything.)

--Andy

>
> --
>  Kirill A. Shutemov
