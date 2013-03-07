Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3CGInh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:43:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50688 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab3CGIng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:43:36 -0500
Date: Thu, 7 Mar 2013 09:43:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: x230: unhandled HKEY event 0x6050
Message-ID: <20130307084330.GA5239@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	ibm-acpi-devel@lists.sourceforge.net,
	lkml <linux-kernel@vger.kernel.org>
References: <20130304213804.GE22274@pd.tnic>
 <20130307003016.GA21655@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130307003016.GA21655@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:30:16PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 04 Mar 2013, Borislav Petkov wrote:
> > I get this in dmesg with 3.9-rc1:
> > 
> > [   12.951434] thinkpad_acpi: unhandled HKEY event 0x6050
> > [   12.951438] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
> > [   13.516752] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
> > 
> > when pressing Fn+F8/F9, i.e. the display backlight keys. I'm loading
> > thinkpad_acpi with brightness_enable=1 and booting the kernel with
> > "acpi_backlight=vendor" so that the backlight intensity gets controlled
> > by thinkpad_acpi. But the last maybe shouldn't complain about it, no?
> 
> It shouldn't even work right on a x230, that box should be doing standard
> ACPI backlight control...

The standard ACPI crap doesn't work - if I don't boot with
acpi_backlight=vendor I get a blinding max level backlight which cannot
be modified by pressing the keys.

The thing is, with "acpi_backlight=vendor" and thinkpad_acpi loaded
with "brightness_enable=1" the backlight actually gets modified nicely
so thinkpad_acpi supports it after all. Maybe the simplest fix is for
thinkpad_acpi to shut up about this button when brightness_enable is set
and maybe when the model is x230?

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
