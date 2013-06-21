Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423286Ab3FUHec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:34:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43383 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901Ab3FUHea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:34:30 -0400
Date: Fri, 21 Jun 2013 09:34:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130621073419.GC22006@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130620073943.GE32694@pd.tnic>
 <51C3531D.3000600@linux.vnet.ibm.com>
 <20130620192928.GD19877@pd.tnic>
 <51C36288.4050405@linux.vnet.ibm.com>
 <20130620205726.GA20863@pd.tnic>
 <51C37291.40303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C37291.40303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 02:52:25AM +0530, Naveen N. Rao wrote:
> Exactly, but mce_poll_banks also doesn't have bits set for banks on
> which CMCI is enabled.
>
> Let's say we have a cpu with 2 banks (not shared), none of which work
> in FF mode. Both these banks support CMCI, so mce_poll_banks won't
> have these bits set.
>
> On cpu offline, we call cmci_clear() which disables CMCI on these two
> banks before offlining it. When this cpu is brought online again, we
> call cmci_discover() which sees that mce_poll_banks doesn't have these
> two banks enabled and will skip enabling CMCI thinking these are in
> FF.

Hmm, mce_intel has yet another bitfield - mce_banks_owned. (Btw, this is
why I have a problem with adding yet another bitfield).

The way I understand it is, if a bit is set in the owned bitfield, those
banks belong to CMCI and are not polled.

Now, can we use both mce_banks_owned and mce_poll_banks? If a bit in
both bifields is cleared, the corresponding bank is not polled *and* is
not owned by CMCI => it is in FF mode.

Makes sense?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
