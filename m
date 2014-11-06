Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKFL4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:56:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33636 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKFL4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:56:40 -0500
Date: Thu, 6 Nov 2014 12:56:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] x86: Drop redundant memory-block sizing code
Message-ID: <20141106115636.GA4318@pd.tnic>
References: <ojh5M-xh-17@gated-at.bofh.it>
 <1415249414-20888-1-git-send-email-daniel@numascale.com>
 <20141106094007.GA4849@pd.tnic>
 <545B4E84.7050707@numascale.com>
 <20141106104034.GB4849@pd.tnic>
 <545B5735.8000401@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <545B5735.8000401@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 07:10:45PM +0800, Daniel J Blueman wrote:
> "As the first check for 64GB or larger memory returns a 2GB memory
> block size in that case, the following check for less than 64GB will
> always

Right, but why isn't there a simple else? Instead, the >64GB case is
looking at totalram_pages but the so-called else case is looking at
max_pfn. Why, what's the difference?

My purely hypothetical suspicion is this thing used to handle some
special case with memory holes where totalram_pages was still < 64GB but
max_pfn was above. I'm looking at this memory block size approximation
downwards which supposedly used to do something at some point, right?

Now, when you remove this, it doesn't do so anymore, potentially
breaking some machines.

Or is this simply unfortunate coding and totalram_pages and max_pfn are
equivalent?

Questions over questions... Maybe it is time for some git log
archeology...

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
