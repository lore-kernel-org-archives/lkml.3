Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3F0VvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:51:09 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:54535
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752773Ab3F0VvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:51:08 -0400
Message-Id: <201306272150.r5RLoq2u006119@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Johan Hovold <jhovold@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
In-Reply-To: Message from Johan Hovold <jhovold@gmail.com>
   of "Wed, 26 Jun 2013 12:39:24 +0200." <20130626103924.GA30828@localhost>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se> <20130619225315.GB12282@kroah.com> <201306212308.r5LN8C7M020720@eskarina.iko.pp.se> <20130621235603.GA1603@kroah.com> <201306221854.r5MIshv5013882@eskarina.iko.pp.se> <20130625233911.GA1087@kroah.com> <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se><20130626103924.GA30828@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6117.1372369852.1@eskarina.iko.pp.se>
Date: Thu, 27 Jun 2013 23:50:52 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Thu, 27 Jun 2013 23:50:56 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Wed, 26 Jun 2013 12:39:24 +0200, Johan Hovold writes:
>On Wed, Jun 26, 2013 at 10:29:59AM +0200, Anders Hammarquist wrote:
>> In a message of Tue, 25 Jun 2013 16:39:11 -0700, Greg KH writes:
>> >> Indeed. I'd already had some (failed) thoughts about how to handle it
>> >> nicely. Now I've had another think through, and I have something which
>> >> deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
>> >> without changing the initializer. Patch 2/2
>> >
>> >Why don't we just drop the extra id thing entirely?  The usb-serial
>> >subsystem handles new device ids being added dynamically from sysfs for
>> >a long time now.  Removing this module option would clean up the code a
>> >lot, and prevent these errors from ever happening again.
>> 
>> Aha, yes, I'm all for that (had I only known I'd have done that to start
>> with). I'll look in to it.
>
>I already have a few patches here (part of a larger 3.11 clean-up series)
>which removes the vid/pid module parameters from all usb-serial modules
>including ti_usb_3410_5052.
>
>I hope to be able to submit the whole series a later tonight, but here's
>the ti_usb_3410_5052 part if anyone's interested.

I did a quick check of adding the device id though sysfs, and although
it partly works, it doesn't find the correct firmware (it ends up trying
to load 5052 firmware for a 3410 device. Looking at the code it seems
(struct ti_device) td_is_3410 isn't set properly.)

I can take a stab at fixing it in the next few days.

/Anders
