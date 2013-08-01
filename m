Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3HAU1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:27:52 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50032 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130801200008.GA5495@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz> <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz> <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz> <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz> <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <CAErSpo4XrJL48boVNiEb-7Y=52Bx_79hqP909ayLOdm7we_m3Q@mail.gmail.com> <20130801200008.GA5495@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 1 Aug 2013 14:27:29 -0600
Message-ID: <CAErSpo4Dw9Bg059scx-YzR=5rpkc65f0hjQnM7STtoprOLXJqw@mail.gmail.com>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
To: Pavel Machek <pavel@ucw.cz>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 2:00 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > But since the problem also occurs with Windows, it's pretty likely
>> > that there's a BIOS update to fix it.  I notice on the X60 support
>> > page that there are several versions newer than what you're running.
>>
>> Do you have any interest in trying a newer BIOS to see if it's fixed
>> there?  If not, I understand; BIOS updates are a hassle at best.
>> You're running BIOS 2.14, and it looks like the current BIOS for an
>> X60 1709 7HU is 2.19 (from http://support.lenovo.com).
>
> I'm lost at the lenovo pages :-(. And frankly I'd prefer not to touch
> the BIOS.

I tried to provide a complete link, but the web site isn't amenable to
that.  I found it by selecting the "Drivers & Software" section,
entering "X60" as the machine type, selecting "ThinkPad X60 (1709)"
and going to the "BIOS" section.  I was surprised how easy it was :)

>> Carolyn's patch will likely work, at least most of the time, but I
>> think there's a small possibility that it could cause a conflict
>> between the BIOS and the OS over ASPM control, so I'm not 100% in
>> support of that approach.  A conflict may not happen on your
>> machine,
>
> Can we base it on DMI  whitelist?

I don't think we can know a priori whether a machine (even your
machine) is susceptible to a conflict.  But if Carolyn forcibly
disables it in the driver, she can structure that with a whitelist or
whatever she thinks is best.

Bjorn
