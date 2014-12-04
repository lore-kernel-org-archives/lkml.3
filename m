Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaLDIuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:50:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56001 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaLDIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:50:06 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Thu, 04 Dec 2014 09:50:02 +0100
Message-ID: <4874352.BarQGyiSH1@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0-rc7+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141203084319.GA52608@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <1416754245-15550-1-git-send-email-pali.rohar@gmail.com> <20141203084319.GA52608@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 00:43:21 Darren Hart wrote:
> > +     int kbd_timeouts[];
> >
> >  };
> >  
> >  static struct quirk_entry *quirks;
> >
> > @@ -76,6 +89,10 @@ static int __init dmi_matched(const struct
> > dmi_system_id *dmi)>
> >       return 1;
> >  }
> >  
> >
> > +static struct quirk_entry quirk_dell_xps13_9333 = {
> > +     .kbd_timeouts = { 0, 5, 15, 60, 5*60, 15*60, -1 },
> 
> Where did these values come from? Were they documented in the
> libsmbios project? Can you provide a URL to that? These really should
> be described by the firmware, but if they aren't, nothing we can do
> about it.

I took those values from a Windows utility provided by Dell. I tried
to find a reason for that specific list to exist, but I couldn't. The
reason why it's there is that the BIOS of my laptop accepts any timeout,
but it silently sets the timeout to 0 (i.e. illumination never off)
if a value not in that list is given. So, given the wide range of
of possible input values, we added that quirk. This is something my
laptop does, Pali's behaves differently and such a list is not needed.
