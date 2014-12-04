Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaLDVb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:31:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61105 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754759AbaLDVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:31:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Thu, 04 Dec 2014 22:53:21 +0100
Message-ID: <2093670.E6uys7cU8v@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141204104819.25015C40992@trevor.secretlab.ca>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <1926483.B4ieFnCBlM@vostro.rjw.lan> <20141204104819.25015C40992@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 04, 2014 10:48:19 AM Grant Likely wrote:
> On Tue, 25 Nov 2014 22:40:53 +0100
> , "Rafael J. Wysocki" <rjw@rjwysocki.net>
>  wrote:
> > On Tuesday, November 25, 2014 08:27:22 PM Mark Brown wrote:
> > > 
> > > --ReaqsoxgOBHFXBhH
> > > Content-Type: text/plain; charset=us-ascii
> > > Content-Disposition: inline
> > > 
> > > On Tue, Nov 25, 2014 at 09:31:27PM +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:
> > > 
> > > > > This is a current topic with the ACPI working group. We have the
> > > > > following document:
> > > 
> > > > > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > > 
> > > > This hasn't been discussed a lot at the meetings I attended.
> > > 
> > > > The bindings management process is being set up within the UEFI Forum, but I'm
> > > > not sure if/how the existing DT bindings documented in the kernel tree are
> > > > going to be covered by it ATM.
> > > 
> > > Al Stone (CCed) pointed me at the following two documents:
> > > 
> > > http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
> > > http://www.uefi.org/sites/default/files/resources/nic-request-v2.pdf
> > > 
> > > (the first one being the actual process in so far as it exists).  The
> > > process appears to be to mail requests in a specific format to the ASWG
> > > chairperson (the address is apparently supposed to be awsg@uefi.org).
> > > It looks like all the properties are expected to end up in one or more
> > > PDF files like the second one.
> > > 
> > > My initial thought would be to require that we send any DT properties
> > > defined for devices with ACPI identifiers registered there and hope the
> > > volume doesn't DoS them.
> > 
> > We absolutely need to start registering the existing bindings in there, but
> > that needs to be rate limited somehow, because the process may not be very
> > efficient to start with.
> 
> Beyond having the document point to the existing DT binding
> documentation, I think this is a non-starter. It won't be helpful for
> anyone to have two separate repositories containing the same bindings.

If they *are* the same, it won't.  But at least in some cases (eg. GPIO)
they won't be the same.

Also we need a way to say "this binding has been documented elsewhere, see XYZ
and this is how to translate the format" in the UEFI documentation for the
existing bindings that will be the same.

> They will get out of sync and we will have pain as a result.
> 
> For existing bindings we need to have a way to share the documentation,
> and I don't think we can even talk about whether it makes sense to
> migrate the documetation to the UEFI managed repo before the UEFI process is
> fully flushed out.

Agreed.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
