Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaKZWsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:48:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63536 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753110AbaKZWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:48:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Thu, 27 Nov 2014 00:09:55 +0100
Message-ID: <7202604.4LK4s7RH1S@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141126111716.GE7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <54753168.9010303@linux.intel.com> <20141126111716.GE7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 26, 2014 11:17:16 AM Mark Brown wrote:
> 
> --4mL5lf+nIvB09VHj
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Tue, Nov 25, 2014 at 05:48:24PM -0800, Darren Hart wrote:
> > On 11/25/14 10:43, Mark Brown wrote:
> 
> > > Link from where - do we want to talk to the ACPI/UEFI forum and
> > > figure out some kind of fast track process for them to add an "it's
> > > already covered by DT, see here" entry to their database for
> > > example?  We also ought to work out how to make sure ACPI IDs are
> > > registered there as well, should be possible to have something
> > > simple as part of that.
> 
> > As to registering ACPI IDs, I believe this is the right link:
> > http://www.uefi.org/PNP_ACPI_Registry
> 
> No, those are vendors as far as I can tell.  I mean identifiers for
> specific devices - it appears to be common for for example Intel to
> allocate identifiers for devices they don't produce, I'd expect there to
> be some effort to keep track of that especially given that _DSD
> properties may well end up being specific to the identifier used to
> register in cases of parallel evolution.

The vendor (or more precisely the owner of the initial 3 or 4 letter code)
is supposed to do that.  I'm not aware of any common registry of those IDs
for all vendors.

> > Or did you mean a HID/CID<->DSD mapping?
> 
> I don't really know what that is, sorry.

The device ID is supposed to determine the way all of the ACPI objects for that
device will work, including what is returned by _DSD.  Pretty much in analogy
with PCI device IDs.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
