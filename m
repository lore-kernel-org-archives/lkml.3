Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaLEBpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:45:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbaLEBpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:45:12 -0500
Date: Wed, 3 Dec 2014 03:51:37 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141203115135.GA42394@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
 <20141203084319.GA52608@vmdeb7>
 <4874352.BarQGyiSH1@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4874352.BarQGyiSH1@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 09:50:02AM +0100, Gabriele Mazzotta wrote:
> On Wednesday 03 December 2014 00:43:21 Darren Hart wrote:
> > > +     int kbd_timeouts[];
> > >
> > >  };
> > >  
> > >  static struct quirk_entry *quirks;
> > >
> > > @@ -76,6 +89,10 @@ static int __init dmi_matched(const struct
> > > dmi_system_id *dmi)>
> > >       return 1;
> > >  }
> > >  
> > >
> > > +static struct quirk_entry quirk_dell_xps13_9333 = {
> > > +     .kbd_timeouts = { 0, 5, 15, 60, 5*60, 15*60, -1 },
> > 
> > Where did these values come from? Were they documented in the
> > libsmbios project? Can you provide a URL to that? These really should
> > be described by the firmware, but if they aren't, nothing we can do
> > about it.
> 
> I took those values from a Windows utility provided by Dell. I tried
> to find a reason for that specific list to exist, but I couldn't. The
> reason why it's there is that the BIOS of my laptop accepts any timeout,
> but it silently sets the timeout to 0 (i.e. illumination never off)
> if a value not in that list is given. So, given the wide range of
> of possible input values, we added that quirk. This is something my
> laptop does, Pali's behaves differently and such a list is not needed.

Let's get a comment above the quirk describing the scenario.


-- 
Darren Hart
Intel Open Source Technology Center
