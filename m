Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaGGWJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:09:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaGGWJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:09:22 -0400
Date: Tue, 8 Jul 2014 00:09:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: linux-edac <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 3/4] MCE, CE: Wire in the CE collector
Message-ID: <20140707220918.GE4776@pd.tnic>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
 <1404242623-10094-4-git-send-email-bp@alien8.de>
 <1404752411.4484.25.camel@oc3432500282.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404752411.4484.25.camel@oc3432500282.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:00:11AM -0700, Max Asbock wrote:
> The above code is a bit convoluted, it amounts to:
> 
> if (we have a corrected dram error && we have an address for it)
> 	mce_ring_add()
> else
> 	mcelog()
> 
> Is that the intention?

Yes.

> This might be problematic for downstream consumers of the errors
> such as the EDAC drivers which keep counts of errors. If errors are
> silently removed from the stream these counts will be bogus. Somebody
> might wonder why a page was off-lined while the EDAC driver reports
> zero corrected DRAM error counts.

This is one of the things that needs discussion. First of all, this
solution aims to be generic enough, even for boxes which don't have an
EDAC driver.

Because if you don't have an EDAC driver, you'd still want to have some
sort of error mitigation.

Granted, most boxes *do* have an EDAC driver but still...

Then, the question is becoming very interesting: how much do we want
EDAC to get involved in the whole deal? Because if we're doing the error
collecting, decaying and page offlining in the kernel, I don't see why
we would need EDAC at all. Or any other agent for that matter.

Maybe for the counters only, if we have to be fair. If, say, people
would want to monitor error levels or so.

I guess we can add some interface which only increments the error counts
without the other error handling EDAC normally would do...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
