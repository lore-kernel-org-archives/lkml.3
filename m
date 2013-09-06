Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3IFXKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:10:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64410 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3IFXKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:10:07 -0400
Date: Fri, 6 Sep 2013 16:10:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Subject: Re: [GIT] HID for 3.12 merge window
Message-ID: <20130906231002.GA32330@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
 <20130906202022.GA353@x4>
 <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
 <20130906215910.GA356@x4>
 <CANq1E4Q4mxKVJJEPNSb9kvUoMXc3KoAnxjnKd0Vx+hoGaeN=kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Q4mxKVJJEPNSb9kvUoMXc3KoAnxjnKd0Vx+hoGaeN=kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 12:51:27AM +0200, David Herrmann wrote:
> Hi
> 
> On Fri, Sep 6, 2013 at 11:59 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2013.09.06 at 23:50 +0200, David Herrmann wrote:
> >> Hi
> >>
> >> On Fri, Sep 6, 2013 at 10:20 PM, Markus Trippelsdorf
> >> <markus@trippelsdorf.de> wrote:
> >> > On 2013.09.06 at 14:00 +0200, Jiri Kosina wrote:
> >> >>
> >> >> David Herrmann (12):
> >> > ...
> >> >>       HID: wiimote: add support for Guitar-Hero drums
> >> >
> >> >  commit 61e00655e9cb82e034eb72b95a51072e718d14a7
> >> >  Author: David Herrmann <dh.herrmann@gmail.com>
> >> >  Date:   Mon Aug 26 19:14:46 2013 +0200
> >> >
> >> >      Input: introduce BTN/ABS bits for drums and guitars
> >> >
> >> > The commit above breaks my Logitech mouse. The mouse cursor just sits in
> >> > the middle of the screen and doesn't react to movements. dmesg is
> >> > normal, but Xorg.0.log says:
> >>
> >> Ok, the issue is the kernel assumes ABS_MAX to be a power-of-2 minus 1
> >> (used as mask). That wasn't really obvious to me. Attached is a patch
> >> which should fix that. Could you apply it on top of linus/master and
> >> give it a try?
> >
> > Your patch fixes the issue. Thanks.
> 
> Thanks a lot for reporting+testing!
> 
> I am still not sure how to solve the EVIOCSABS thingy. Problem is,
> it's defined as:
>   #define EVIOCSABS(_abs) ...0xc0 + (_abs)...
> But if (_abs > 0x3f) this will be bigger than 0xff. Unfortunately, the
> upper part of the ioctl is defined as 'E' which is 0x45 in hex and
> thus sets the LSB. That means we cannot extend the _IOC_TYPE field to
> the upper region (which would cause endian-issues, anyway). I guess
> we're screwed here and need to revert that...
> 
> Dmitry, any comment on this? Or am I missing something?

We have gaps below ABS_MT constants, I think for 3.12 you could move
your whammy there and revert ABS_MAX change, but we need to plan for
expanding it in the future.

Thanks.

-- 
Dmitry
