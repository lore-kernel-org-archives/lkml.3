Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3FFNgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:36:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60373 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab3FFNgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:36:13 -0400
Date: Thu, 6 Jun 2013 14:36:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606133609.GK30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606132603.GD20972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun, at 03:26:03PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 11:42:24AM +0100, Matt Fleming wrote:
> > On Sun, 02 Jun, at 02:56:09PM, Borislav Petkov wrote:
> > > +
> > > +static int __init parse_efi_cmdline(char *str)
> > > +{
> > > +	if (*str == '=')
> > > +		str++;
> > > +	if (!strncmp(str, "1:1_map", 7))
> > > +		efi_config |= EFI_CFG_MAP11;
> > > +
> > > +	return 0;
> > > +}
> > > +early_param("efi", parse_efi_cmdline);
> > 
> > This is fine for testing, but I genuinely think that this should be on
> > by default once these patches are final.
> 
> This would break the Macs, remember?
> 
> We could make it be the default though and flip the logic so that users
> can fall back to the current ioremap functionality, i.e. boot with
> "efi=no_1:1_map".

Yeah, or white/blacklist them. We've already had enough of "Oh, your
machine used to work but now it's bust? Yeah, turn on this cmdline
parameter to get things working again".

But the point is that the funnies that have been seen on the Macs should
be treated as the unusual case. The number of machines I've seen that
require this 1:1 map is staggering, especially once you start poking at
some of the other runtime services, like UpdateCapsule().

-- 
Matt Fleming, Intel Open Source Technology Center
