Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3FQILc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:11:32 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60972 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3FQIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:11:29 -0400
Date: Mon, 17 Jun 2013 13:41:03 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
Message-ID: <20130617081103.GA4197@naverao1-tp.in.ibm.com>
References: <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com>
 <20130614181721.11206.95341.stgit@localhost.localdomain>
 <20130615144830.GA13310@pd.tnic>
 <51BEB3F5.8070002@gmail.com>
 <20130617070650.GA7203@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617070650.GA7203@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061708-6102-0000-0000-000003B688C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/06/17 09:06AM, Borislav Petkov wrote:
> On Mon, Jun 17, 2013 at 12:30:05PM +0530, Naveen N. Rao wrote:
> > >Hmm, so if CMCI is not supported, you just disabled polling of this bank
> > >and returned here. Not good.
> > 
> > This is on purpose. If the bank doesn't support CMCI and we were
> > polling it earlier, we want to disable that. The firmware should be
> > notifying us of error events in either case.
> 
> Not for corrected errors - for those we poll since the hardware doesn't
> generate an exception for them.

Yes, we used to poll since we do not get notified via MCE/CMCI. However,
with firmware first set in CMC structure, the firmware is now controlling
all corrected error reporting for these banks. So, we should not be looking
at these MCA banks at all.

> 
> Basically, the absence of CMCI support shouldn't change the old polling
> behavior.

Again, this changes with firmware first mode. The firmware should now
notify us of all corrected errors through GHES.

Thanks,
Naveen

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

