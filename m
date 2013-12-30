Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3L3N00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:26:26 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54114 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3L3N0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:26:25 -0500
Date: Mon, 30 Dec 2013 14:26:19 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131230132619.GA24241@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <20131228211026.GA14725@jak-x230>
 <20131228221003.GA24911@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131228221003.GA24911@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 08:10:03PM -0200, Henrique de Moraes Holschuh wrote:
> On Sat, 28 Dec 2013, Julian Andres Klode wrote:
> > On Mon, Nov 11, 2013 at 02:56:29PM +0100, Julian Andres Klode wrote:
> > > This patch series adds support for specifying charging thresholds,
> > > forcing a battery to discharge, and inhibiting charging, on ThinkPad
> > > Laptops using Sandy Bridge or newer processors.
> > 
[...]
> > Henrique, it would be really great if you could take a look.
> 
> I did.  I just did not manage to finish looking over it, it is not really
> okay as-is, mostly because it did not create a power-supply device and
> properly extended that thing in a generic way, which would be vastly
> preferable to adding yet another private interface.

Thanks for the response.

I think that a more generic approach is a good idea, but
I don't think creating a new power supply device would be the right
choice because this controls existing supplies rather than being a
supply in itself, and I am not aware of any other kind of power
supply device that allows setting things.

We could extend the existing battery devices and then get paths like
	/sys/class/power_supply/BAT0/start_charge_thresh
which looks `natural'. There is one problem with that approach, though:

A ThinkPad supports multiple batteries: In my case, I could add a slice
battery. But the ACPI driver only exposes a BAT0 device without a slice
being attached (I assume a BAT1 will pop-up if you add a slice battery,
but can't test it, as I don't own one). This means that you can only
configure the slice battery when it's plugged in. I don't know if its
a good idea to work like this.

Another problem is that I don't know any other systems supporting charge
thresholds, and I don't want to dictate interfaces built for ThinkPads
as a generic way. 
-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
