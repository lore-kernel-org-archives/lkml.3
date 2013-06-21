Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423385Ab3FUIgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:36:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46533 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161032Ab3FUIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:36:20 -0400
Date: Fri, 21 Jun 2013 10:36:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130621083608.GE22006@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130620073943.GE32694@pd.tnic>
 <51C3531D.3000600@linux.vnet.ibm.com>
 <20130620192928.GD19877@pd.tnic>
 <51C36288.4050405@linux.vnet.ibm.com>
 <20130620205726.GA20863@pd.tnic>
 <51C37291.40303@linux.vnet.ibm.com>
 <20130621073419.GC22006@pd.tnic>
 <51C404EA.10906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C404EA.10906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 01:16:50PM +0530, Naveen N. Rao wrote:
> Yes, but I'm afraid this won't work either - mce_banks_owned is
> cleared during cpu offline. This is necessary since a cmci
> rediscover is triggered on cpu offline, so that if this bank is
> shared across cores, a different cpu can claim ownership of this
> bank.

What for? Sounds strange to me.

Anyway, the reason for which mce_banks_owned won't work is because it
is in mce_intel and we need a mce.c global bitfield for banks which are
excluded from CE handling.

So ok, I'm persuaded, yet another bitfield it is ... :-\

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
