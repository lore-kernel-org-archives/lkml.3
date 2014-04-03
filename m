Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaDCVDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:03:07 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49600 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaDCVDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:03:03 -0400
Date: Thu, 3 Apr 2014 23:03:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v2 1/5] x86: replace timeouts when booting secondary
 CPU with infinite wait loop
Message-ID: <20140403210300.GP22728@two.firstfloor.org>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
 <1396296565-19709-2-git-send-email-imammedo@redhat.com>
 <87ppkzk5zi.fsf@tassilo.jf.intel.com>
 <20140402232956.54848fbe@thinkpad>
 <20140403064337.GA29274@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403064337.GA29274@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:43:37AM +0200, Ingo Molnar wrote:
> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> > > I've seen that. Kernel still boots. With your patch it would hang.
> 
> Nonsense, not booting is OK when critical hardware is genuinely bad - 
> this isn't a disk drive or networking where bad IO 'happens sometimes' 
> and failure is something we have to engineer for - this is the CPU!
> 
> If a critical piece of hardware like the CPU or RAM is non-functional 
> then it should be excluded by the user explicitly, not worked around 
> after some ugly, non-deterministic and fragile timeout.

That's generally not true. We try to recover as best as we can
and continue.

That's true for RCU stalls, and RAM errors (hwpoison) and
other error conditions. It's true for kernel problems
(we try to oops and continue, not to panic etc.)

Hanging forever is not recovering, it's just poor and broken 
error handling and generally not acceptable these days.

-Andi

