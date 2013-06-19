Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab3FSSgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:36:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49956 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab3FSSgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:36:48 -0400
Date: Wed, 19 Jun 2013 20:36:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130619183640.GL28300@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 06:19:25PM +0000, Luck, Tony wrote:
> > Interesting, why? Why would we even need such an option? My impression
> > is, if ACPI tells us FF, MCE code doesn't poll those banks anymore. So
> > where do the duplicated reports come from?
> 
> The option is only disabling the Linux side of firmware first ... the BIOS
> will still be doing it and generating records to feed to the OS using APEI.
> 
> So Linux may see the error in a bank and report it, and BIOS may report
> the same error.  Though I'd expect that to be rare as whoever saw it first
> would most likely clear the bank before the other could see it.
> 
> I asked for the option because I'm nervous about just skipping some banks
> on the say-so of the BIOS ... what if the BIOS did something wrong. This
> option gives us a way to return to the way things were before this patch.

Yeah, the code I saw only disables the banks in the HEST:

	mce_disable_ce_bank(mc_bank->bank_number)

and leaving the rest in poll mode. But I agree, we need this as a
fallback if BIOS is doing other crack smoking exercises and thus we want
to ignore FF completely.

> These parts are now looking good ... but we still need to tackle what
> Linux does when it does get the CPER record. I suspect we need to
> preserve the existing "fake an mcelog entry with just the address" on
> old platforms, but need to do something smarter on new ones.

Why, fill out struct mce and do mce_log(mce) does not suffice?

I'll take a look at the rest of the stuff tomorrow, on a clear head.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
