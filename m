Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaAQRC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:02:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52832 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaAQRCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:02:22 -0500
Date: Fri, 17 Jan 2014 18:02:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Kim Naru <kim.naru@amd.com>, Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140117170213.GG8715@pd.tnic>
References: <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
 <20140114203848.GP29865@pd.tnic>
 <52D81DB5.7000608@amd.com>
 <20140117002123.GA9165@khazad-dum.debian.net>
 <20140117101842.GB8715@pd.tnic>
 <52D958FC.9020700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D958FC.9020700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:23:24AM -0800, H. Peter Anvin wrote:
> Actually I by and large disagree with that. There is a limit, of
> course, but when it comes to flipping an MSR in init code, the bar is
> pretty darn low. We have quirks for all kind of hardware, and this is
> just another example.

No, you don't. :-)

You would much prefer to have the workaround done in the BIOS and only
if there's a coverage hole, only then to do it in the kernel.

I'm not saying we shouldn't do it in the kernel per se - I'm saying we
should do it only when really necessary. And it doesn't hurt to talk
about it first before inviting in all fixes for all errata for all
families of all vendors. No, you don't want that, believe me. :-)

> The effort of a kernel update is much lower, especially since the
> kernel is generally automatically updated.

Does that even matter? I think what matters is whether we reboot or not,
i.e. HA crap. If we have to reboot, we might just as well flash the BIOS
- it takes almost as long.

> It would be awesome if that was done for firmware, but in the absence
> of central distribution, arbitrary EOL sunsets, and a standard
> OS-driven firmware installer,

Oh, the brave new world of UEFI wants to address that - it is supposed
to flash the firmware from the OS. OEM vendors have their home grown
solutions already, as I'm sure you know.

> it just isn't going to happen widely Yes, that is a problem.

That definitely is a problem.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
