Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab3FSUOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:14:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57994 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab3FSUOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:14:46 -0400
Date: Wed, 19 Jun 2013 22:14:38 +0200
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
Message-ID: <20130619201438.GM28300@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 07:05:16PM +0000, Luck, Tony wrote:
> > Why, fill out struct mce and do mce_log(mce) does not suffice?
> 
> There is (or should be)

Ha!

> a lot more interesting stuff in the CPER than just the address. Stuff
> that we don't have fields for in the existing mcelog structure. We
> also need to treat filtered records from modern APEI implementations a
> bit differently from the old stuff.

Great, the CPER record is described in the UEFI spec. Those BIOS people
are all like a mafia.

Ok, seriously: so the situation should still be fine, FF reported errors
get the CPER format while the rest, the "old" MCE format.

cper.c is doing printk so I'm guessing it would need to get its own
tracepoint and carry that to userspace.

Concerning the RAS daemon, Robert and I are making good progress so once
we have the persistent events in perf, we can read that tracepoint in
userspace and do whatever we want with the error info.

> The original user of this code was Westmere-EX, which used it as a
> workaround for a missing address in MCi_ADDR for corrected errors.
> So in that scenario we had every error being reported and mcelog(8)
> deamon doing the threshold analysis to decide when to take action.
>
> In this new modern world - Naveen wants to have the BIOS decide the
> threshold, so we'd like Linux to take some action as soon as it sees
> just one CPER.

Why would Linux have to intervene if it is doing FF - wasn't the deal
behind Firmware First for the firmware to get the error first and handle
accordingly?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
