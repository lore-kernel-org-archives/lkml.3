Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877Ab3FTT3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:29:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57342 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965861Ab3FTT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:29:37 -0400
Date: Thu, 20 Jun 2013 21:29:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130620192928.GD19877@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130620073943.GE32694@pd.tnic>
 <51C3531D.3000600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C3531D.3000600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 12:38:13AM +0530, Naveen N. Rao wrote:
> We need this bitfield to prevent enabling CMCI in future
> cmci_discover() invocations. See usage in cmci_discover() further
> below.

So?!

	/* Skip banks in firmware first mode */
	if (!test_bit(i, __get_cpu_var(mce_poll_banks))
		continue;

...

> >Yeah, let's call it ...disable_poll_bank because we're disabling polling
> >for those banks. And yes, we poll for errors for which no MCE exception
> >is generated and those happen to be corrected but still...
> 
> We actually also disable CMCI here. So, in essence, we are disabling
> these banks for all sorts of direct corrected error reporting. I
> thought of naming this disable_ce_on_bank() or disable_ce_bank(),
> but felt that the mce_ prefix would be good to have. If that isn't
> necessary, I can rename this to disable_ce_on_bank() which sounds
> more accurate to me. Is that ok?

No, mce_disable_bank() removes the respective bank from the polling
bitfield and cmci_disable_bank() actually disables CMCI which is
Intel-only. So leave it at mce_disable_bank and that should be fine.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
