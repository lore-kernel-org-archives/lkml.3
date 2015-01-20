Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbbATMTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:19:12 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34128 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbATMTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:19:11 -0500
MIME-Version: 1.0
In-Reply-To: <1421751814.29486.13.camel@linux-0dmf.site>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
 <1421751814.29486.13.camel@linux-0dmf.site>
From: Kirill Elagin <kirelagin@gmail.com>
Date: Tue, 20 Jan 2015 16:18:49 +0400
Message-ID: <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
Subject: Re: USB autosuspend causing trouble with bluetooth
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use a Logitech wireless keyboard (with a Unifying receiver) and it
keeps working fine even with `auto`.

That is, everything is OK if the receiver is plugged before
`power/control` is switched to `auto`.
But if I first set it to `auto`, then plug the receiver in, it is not
detected (nothing in dmesg). Kernel
detects it as soon as I `echo on` to the relevant `power/control`.

This laptop is too old to have USB3.0, both the receiver and BT are
attached to USB1.1 ports.
BTW I also noticed a strange thing: USB devices appear on different
buses when attached,
depending on their speed (e.g. the keyboard receiver is on bus 6 which
is USB1.1, while a
USB stick appears on bus 2 which is USB2.0 when I plug it into that
same physical port).
I’m not sure whether this is strange or normal, as I never really
payed attention.


On Tue Jan 20 2015 at 2:03:45 PM Oliver Neukum <oneukum@suse.de> wrote:
>
> On Sun, 2015-01-18 at 17:30 +0400, Kirill Elagin wrote:
> > Hello,
> >
> > Recently I started having issues with my Apple Magic Trackpad and I
> > realised that the problem was with autosuspend. Whenever I have `auto`
> > in `power/control` of my BT adapter, `btmon` shows no packets,
> > nothing. As soon as I `echo on`, all the missing packets arrive.
>
> You are not getting remote wakeups. There are two possibilities
>
> 1. the firmware of your BT adapter is faulty and the device needs to
> be added to the list of quirky devices
>
> 2. a bug in the kernel breaks remote wakeup.
>
> We need to distinguish these cases. Could you connect another device
> that uses remote wakeup (HID, CDC-ACM, ... - a keyboard or a mouse is
> easiest) to a port connected to XHCI and test autosuspend on that
> device?
>
>         Regards
>                 Oliver
>
>
>
>
