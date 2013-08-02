Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3HBCNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:13:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBCNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:13:11 -0400
Date: Fri, 2 Aug 2013 04:13:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130802021259.GA3715@amd.pavel.ucw.cz>
References: <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <CAErSpo4XrJL48boVNiEb-7Y=52Bx_79hqP909ayLOdm7we_m3Q@mail.gmail.com>
 <20130801200008.GA5495@amd.pavel.ucw.cz>
 <CAErSpo4Dw9Bg059scx-YzR=5rpkc65f0hjQnM7STtoprOLXJqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4Dw9Bg059scx-YzR=5rpkc65f0hjQnM7STtoprOLXJqw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > But since the problem also occurs with Windows, it's pretty likely
> >> > that there's a BIOS update to fix it.  I notice on the X60 support
> >> > page that there are several versions newer than what you're running.
> >>
> >> Do you have any interest in trying a newer BIOS to see if it's fixed
> >> there?  If not, I understand; BIOS updates are a hassle at best.
> >> You're running BIOS 2.14, and it looks like the current BIOS for an
> >> X60 1709 7HU is 2.19 (from http://support.lenovo.com).
> >
> > I'm lost at the lenovo pages :-(. And frankly I'd prefer not to touch
> > the BIOS.
> 
> I tried to provide a complete link, but the web site isn't amenable to
> that.  I found it by selecting the "Drivers & Software" section,
> entering "X60" as the machine type, selecting "ThinkPad X60 (1709)"
> and going to the "BIOS" section.  I was surprised how easy it was :)

Hmm. So I've update bios using 7buj28uc.iso . Reverted the patches and
yes, ping latencies are still bad:

pavel@amd:~$ ping 10.0.0.250
PING 10.0.0.250 (10.0.0.250) 56(84) bytes of data.
64 bytes from 10.0.0.250: icmp_req=1 ttl=127 time=1.05 ms
64 bytes from 10.0.0.250: icmp_req=2 ttl=127 time=0.820 ms
64 bytes from 10.0.0.250: icmp_req=3 ttl=127 time=73.5 ms
64 bytes from 10.0.0.250: icmp_req=4 ttl=127 time=7.41 ms
64 bytes from 10.0.0.250: icmp_req=5 ttl=127 time=5.25 ms
64 bytes from 10.0.0.250: icmp_req=6 ttl=127 time=1.16 ms
64 bytes from 10.0.0.250: icmp_req=7 ttl=127 time=36.3 ms
64 bytes from 10.0.0.250: icmp_req=8 ttl=127 time=1.64 ms

> >> Carolyn's patch will likely work, at least most of the time, but I
> >> think there's a small possibility that it could cause a conflict
> >> between the BIOS and the OS over ASPM control, so I'm not 100% in
> >> support of that approach.  A conflict may not happen on your
> >> machine,
> >
> > Can we base it on DMI  whitelist?
> 
> I don't think we can know a priori whether a machine (even your
> machine) is susceptible to a conflict.  But if Carolyn forcibly

We don't apriori now how broken machines are, true. There are 1000
ways BIOS can break things. And yes, it will be us breaking the specs
here. But "useful machine with OS breaking specs" is better than
"machine useless for ssh".

_If_ there's a conflict, we can try something else.

(Has someone really seen a conflict, or is it just theoretical thing?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
