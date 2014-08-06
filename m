Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaHFMZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:25:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45109 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaHFMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:25:50 -0400
Date: Wed, 6 Aug 2014 14:25:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Janek Kozicki <janek_listy@wp.pl>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, markus@gutschke.com,
        Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16 crashes on resume from Suspend-To-disk
Message-ID: <20140806122548.GA10751@amd.pavel.ucw.cz>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <20140804141613.GB24261@amd.pavel.ucw.cz>
 <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
 <11544482.e7kpiLjKfi@vostro.rjw.lan>
 <20140805115834.5e5e76f0@absurd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805115834.5e5e76f0@absurd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-08-05 11:58:34, Janek Kozicki wrote:
> Rafael J. Wysocki said:     (by the date of Tue, 05 Aug 2014 03:30:58 +0200)
> 
> > On Monday, August 04, 2014 09:06:52 AM Markus Gutschke wrote:
> > > Thanks for checking in. And no, I have not heard from Zhang since my
> > > last e-mail. I suspect he is still working on finding a solution. But
> > > you are of course right, reverting the patch in the meantime might be
> > > a good idea.
> > 
> > It has too many dependencies.  Besides, reverting it now (at the beginning of
> > a merge window) won't be particularly useful anyway.
> > 
> > We need to fix it.
> 
> 
> Hi, sorry for hijacking this thread, but apparently my other plead
> for help got ignored in this very busy mailing list.
> 
> I have an up-to-date recently installed debian wheezy. I downloaded
> https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:
> 
>   cp /boot/config-`uname -r` ./.config
>   make menuconfig
>   fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
>   dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb
> 
> where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64
> 
> my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI
> 
> I just did 25 tries of suspend/resume cycle. I tried 4 different
> methods of hibernation, you will find a full summary of my tries
> (including how many failures for each method) in attached script
> SLEEP.sh which I always used to perform hibernation.
> 
> The failure was always a reboot after resume had almost succeeded. In
> cases when there was a success there was a following ---[cut
>here]--- part:

The Intel audio driver seems to be requesting firmware... Can you
rmmod snd_hda_codec_ca0132 and similar modules, and retry hibernation?
										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
