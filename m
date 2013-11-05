Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3KELws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:52:48 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63840 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3KELwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:52:45 -0500
Date: Tue, 5 Nov 2013 12:52:39 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131105115239.GA15635@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1383601088-21177-1-git-send-email-jak@jak-linux.org>
 <87ppqfrw2t.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ppqfrw2t.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:18:02AM +0100, Bjørn Mork wrote:
> Julian Andres Klode <jak@jak-linux.org> writes:
> 
> >  
> > +TPACPI_HANDLE(battery, root, "\\_SB.PCI0.LPC.EC.HKEY",
> > +	   "\\_SB.PCI0.LPCB.EC.HKEY",		/* X121e, T430u */
> > +	   "\\_SB.PCI0.LPCB.H_EC.HKEY",		/* L430 */
> > +	   "\\_SB.PCI0.LPCB.EC0.HKEY",		/* Edge/S series */
> > +	   );
> > +
> 
> Isn't this just the full patch to the existing "hkey_handle" for those
> models?  Why not just use that handle, like e.g the rfkill driver does?

I did not notice it, thanks for pointing that out.

> 
> Supported models could probably be autodetected by checking whether the
> methods exist?

Yes, this makes more sense. I modified it locally to check for existence
of BCTG (get start threshold) and set tp_features.battery accordingly. If
it exists, all features are enabled (I think we can safely assume their
existence, I don't know if there are really thinkpads where you can get
a start threshold but don't have one of the other functions).


> 
> > +static struct attribute_group bat##_BAT##_attribute_group = { \
> > +	.name  = "BAT" #_BAT, \
> > +	.attrs = bat##_BAT##_attributes \
> > +};
> 
> Are these names guaranteed to match the ACPI battery device(s)?

At least on the Sandy Bridge series and older, the first battery
(BAT0 here) always refers to the internal battery, and BAT1 to
the external one. I think this should match the ACPI battery
devices. 

On the Haswell ones, I don't know, because they have one non-removable
built-in and one removable.

> 
> > +DEFINE_BATTERY(0);
> > +DEFINE_BATTERY(1);
> 
> Are there always two batteries?

As far as I can tell, the controller supports up to 2 batteries. And
they can be configured while they are not plugged in. So, exporting
both of them (all the time) makes sense.

I don't know if the W520 or W530 support 3 batteries, as I don't
have access to them. If they do, I don't know whether they will be
two separate entries or controlled by the same one.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
