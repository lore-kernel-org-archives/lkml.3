Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162332AbaDCGno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:43:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39390 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162303AbaDCGnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:43:41 -0400
Date: Thu, 3 Apr 2014 08:43:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        riel@redhat.com, gong.chen@linux.intel.com
Subject: Re: [PATCH v2 1/5] x86: replace timeouts when booting secondary CPU
 with infinite wait loop
Message-ID: <20140403064337.GA29274@gmail.com>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
 <1396296565-19709-2-git-send-email-imammedo@redhat.com>
 <87ppkzk5zi.fsf@tassilo.jf.intel.com>
 <20140402232956.54848fbe@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402232956.54848fbe@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> > I've seen that. Kernel still boots. With your patch it would hang.

Nonsense, not booting is OK when critical hardware is genuinely bad - 
this isn't a disk drive or networking where bad IO 'happens sometimes' 
and failure is something we have to engineer for - this is the CPU!

If a critical piece of hardware like the CPU or RAM is non-functional 
then it should be excluded by the user explicitly, not worked around 
after some ugly, non-deterministic and fragile timeout.

The timeout in the SMP bringup code was really an ancient property, 
introduced back more than a decade ago when hardware makers were 
ignorant of Linux we were ignorant of how to properly interface with 
SMP hardware.

Today a 'timeout' means one of 3 things:

  - bad, fragile hardware - this we don't want to hide, unless 
    explicitly told so by the user. I've seen such symptoms related to 
    overclocking for example - so not booting is perfectly justified, 
    it can prevent reporting a bogus kernel crash down the line.

  - buggy SMP bringup. That is a bug that needs to be fixed, not 
    worked around.

  - timeout fragility in virtualized environments

I'm not aware of any genuine case where timing out is the correct 
thing to do.

So the patches look fine to me as-is, I planned on looking at them 
more closely after the merge window.

Thanks,

	Ingo
