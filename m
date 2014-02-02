Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaBBThS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 14:37:18 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52873 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBBThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 14:37:16 -0500
Message-ID: <1391369816.2750.19.camel@canaries32-MCP7A>
Subject: Re: rtl8821ae.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Dave Jones <davej@redhat.com>, gregkh@linuxfoundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        Andrea Merello <andrea.merello@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linux Driver Project <devel@linuxdriverproject.org>
Date: Sun, 02 Feb 2014 19:36:56 +0000
In-Reply-To: <201402021807.37772.s.L-H@gmx.de>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
	 <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 18:07 +0000, Stefan Lippers-Hollmann wrote:
> Hi
> 
> [ CC'ing the relevant parties ]
> 
> On Sunday 02 February 2014, Dave Jones wrote:
> > On Sun, Feb 02, 2014 at 03:41:27AM -0800, scan-admin@coverity.com wrote:
> >  > 
> >  > Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
> >  > 
> >  > Defect(s) Reported-by: Coverity Scan
> >  > Showing 20 of 83 defect(s)
> > 
> > Ugh, this is even worse than the usual realtek drivers. (With the exception of rtl8188eu)
> > All 83 of those new defects came from this new driver, and while there's
> > a bunch of "who cares" type things in there, there's a load of stuff that
> > needs fixing a lot more urgently than CodingStyle issues or anything else in the TODO
> > for that driver.
> > 
> > A bigger problem though, is what is the plan for these realtek drivers ?
> > They've been in staging forever. rtl8187se has been there for _five_ years with
> > no indication it's ever getting promoted to first class status.
> 
> Actually rtl8187se (aka rtl8185b) seems to have gotten some attention 
> recently:
> 
> http://lkml.kernel.org/r/CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com
> 
> > The git logs are littered mostly with CodingStyle cleanups, sparse cleanups and such,
> > meanwhile for five years they've had out of bounds reads, overflows, and such 
> > for this whole time.  Even worse, when one of the drivers gets fixes for actual
> > problems like this, they never make it back to Realtek, who clone the same
> > old shitty driver they shipped last time, and reintroduce new variants of the
> > same damn bugs, and then we import the new turd into staging and start all over again.
> > 
> > I get the whole "a shit driver is better than no driver", but there's no discernable
> > effort to ever improve this pile, just to keep adding to it.
> > 
> > 	Dave
> 
> I think there are mostly two major problems with these drivers, besides 
> RealTek still working on a non-mac80211 codebase for USB based devices.
> 
> The sheer number of slightly different RealTek drivers for similar
> chipsets, for which RealTek as forked off a dedicated driver each, 
> rather than extending the existing ones. With the other, probably even 
> larger, problem being that it isn't possible to port wireless drivers
> from non-mac80111 to mac80211 in a gradual fashion, it's always a 
> parallel re-implementation. Just look at the recent history of staging
> wireless drivers:
> 
> the successful ones:
> - csr --> /dev/null
> - otus --> ar9170 --> carl9170
> - ( rt2870 && rt3070 ) --> rt2800usb
> - rt2870 --> rt2800pci
> - [ at76c503a --> ] at76_usb --> at76c50x-usb   [*] not in staging
> 
> the pending ones
> - rtl8187se [ --> rtl8180 ]   [*] hopefully soon
> - rtl8188eu --> ?
> - [ rtl8192du --> ? ]   [*] not in staging, [1]
> - rtl8192e --> ?
> - rtl8192u --> ?
> - rtl8192su --> rtl8712 --> ? [ r92su[2] would add cfg80211 support, 
>                                 but it being a fullmac like
>                                 re-implementation doesn't get it 
>                                 anywhere ]
> - rtl8821ae [ --> mac80211 port planned for 3.15[3]? ]
> 
> these devices are, besides rtl8187se (802.11g) and rtl8821ae 
> (802.11ac), all 802.11n compatible, but were quickly EOLed by the 
> vendor, probably making it hard to get enough traction for a proper 
> mac80211 port. Coincidentally these chipsets are also very popular, 
> rtl8187se being the chipset of the early netbook craze, rtl8188eu 
> pretty ubiquitous on embedded platforms, the others making the bulk 
> of aftermarket USB devices.
> 
> ancient hardware, probably not going anywhere:
The below devices are still been sold new
> - vt6655 --> ?
> - vt6656 --> ?
to mac80211

I have already done the conversion, just some minor things todo
LED/ host implementation

Should be ready to merge next + 3-4.

I will update the TODO file shortly.

> - wlags49_h2 --> ?
> - wlags49_h25 --> ?
> - wlan-ng --> ?
> 
> This likely leaves staging wireless drivers to small corrections and 
> bugfixes. In the hope that the devices will get enough traction that 
> someone takes up the effort of doing a parallel re-implementation of a
> proper mac80211 based driver, using the staging source only as 
> reference.
> 
For my part, it is an educational exercise.

However, I do wonder why I don't simply submit a new driver. There
is very little of the staging code left.

Regards


Malcolm


