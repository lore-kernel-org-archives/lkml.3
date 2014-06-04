Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaFDNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaFDNMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:12:50 -0400
Message-ID: <538F1B33.6030706@redhat.com>
Date: Wed, 04 Jun 2014 09:12:19 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, Oren Twaig <oren@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] x86, Clean up smp_num_siblings calculation
References: <1401709892-9586-1-git-send-email-prarit@redhat.com> <538CA69F.1020305@windriver.com>
In-Reply-To: <538CA69F.1020305@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/02/2014 12:30 PM, Paul Gortmaker wrote:

<snip code>

> I wonder if this code is in need of an update?  I recall reading
> this thread:
> 
> http://forum.osdev.org/viewtopic.php?f=1&t=23445
> 
> which suggests that we try CPUID with 0xb, and then 0x4 _before_
> relying on the EBX[23:16] of the older CPUID 0x1.
> 
> AFAICT, the 0xb and 0x4 didn't exist when AP-485 was written ~2002.
> 
> http://datasheets.chipdb.org/Intel/x86/CPUID/24161821.pdf

FWIW, I agree -- this whole chunk can be rewritten and I'll do that in [v3].

> 
> Also, there was a discussion of masking the "ht" flag in /proc/cpuinfo
> for when it is "off" -- since the common sense interpretation of it
> doesn't match the implementation in the specification:
> 
> http://codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
> https://lkml.org/lkml/2009/11/13/33
> 
> ...but I don't think that ever happened, even though Ingo thought it
> would probably be OK if there was no obvious fallout.

I have spoken to a few people about this to see if we anticipate any fallout
from this.  The only concern that anyone raised is that some admin might get
confused by the lack of the ht flag in /proc/cpuinfo.  I think that's bogus
because it would have been the admin that disabled HT in the first place.  So
AFAICT it should be safe to do.  I'm going to put together a 2/2 of patch only
for the removal of ht if (smp_num_siblings == 1) and we'll see if the
maintainers like it or not.

P.
