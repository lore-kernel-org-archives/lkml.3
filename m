Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3HBNtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:49:01 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60847 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3HBNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130802021259.GA3715@amd.pavel.ucw.cz>
References: <20130709094906.GA3870@amd.pavel.ucw.cz> <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz> <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz> <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <CAErSpo4XrJL48boVNiEb-7Y=52Bx_79hqP909ayLOdm7we_m3Q@mail.gmail.com>
 <20130801200008.GA5495@amd.pavel.ucw.cz> <CAErSpo4Dw9Bg059scx-YzR=5rpkc65f0hjQnM7STtoprOLXJqw@mail.gmail.com>
 <20130802021259.GA3715@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Aug 2013 07:48:37 -0600
Message-ID: <CAErSpo5dUEO8UX650Y=tx9Wp-w27k6JWU3WKpUPxiiV-tUULiw@mail.gmail.com>
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

On Thu, Aug 1, 2013 at 8:13 PM, Pavel Machek <pavel@ucw.cz> wrote:

> Hmm. So I've update bios using 7buj28uc.iso . Reverted the patches and
> yes, ping latencies are still bad:

Wow.  I can hardly believe how bad this is (assuming Windows has the
same problem).  Thanks a lot for checking this out.

>> >> Carolyn's patch will likely work, at least most of the time, but I
>> >> think there's a small possibility that it could cause a conflict
>> >> between the BIOS and the OS over ASPM control, so I'm not 100% in
>> >> support of that approach.  A conflict may not happen on your
>> >> machine,
>> >
>> > Can we base it on DMI  whitelist?
>>
>> I don't think we can know a priori whether a machine (even your
>> machine) is susceptible to a conflict.  But if Carolyn forcibly
>
> We don't apriori now how broken machines are, true. There are 1000
> ways BIOS can break things. And yes, it will be us breaking the specs
> here. But "useful machine with OS breaking specs" is better than
> "machine useless for ssh".
>
> _If_ there's a conflict, we can try something else.
>
> (Has someone really seen a conflict, or is it just theoretical thing?)

Completely theoretical, as far as I know.  I don't even know what a
conflict would look like.  Maybe some unexpected ASPM enable/disable
from SMM during suspend/resume or something.  Things like that would
likely go unnoticed anyway.

Bjorn
