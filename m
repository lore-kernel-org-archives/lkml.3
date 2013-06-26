Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3FZUgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:36:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38076 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3FZUgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:36:44 -0400
Date: Wed, 26 Jun 2013 22:36:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
Message-ID: <20130626203639.GM20274@pd.tnic>
References: <20130626091808.GA18468@gchen.bj.intel.com>
 <0134840@agluck-desk.sc.intel.com>
 <20130626190845.GK20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C5653E@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C5653E@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 08:23:47PM +0000, Luck, Tony wrote:
> 	MCESEV(
> > -		KEEP, "HT thread notices Action required: data load error",
> > -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
> > -		MCGMASK(MCG_STATUS_EIPV, 0)
> > +		KEEP, "Action required but unaffected thread is continuable",
> > +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
> 
> > Why did we lose MCACOD_DATA from the MASK above? Was this intentional?
> 
> 
> We used to have separate entries for "HT thread notices ... data load" and "HT thread notices ... instruction load"
> because the old SDM had a complex table calling out the bit settings for each type of recoverable machine check.
> 
> Latest SDM simplifies the table making it clear that for every SRAR (software recoverable action required) error
> we'll have the same bits in MCG_STATUS (EIPV=0, RIPV=1) ... so we don't need to check for the MCACOD value.
> See attached snapshot of the new table.

And this obviously is the case for the hardware too, I assume, not only
the SDM?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
