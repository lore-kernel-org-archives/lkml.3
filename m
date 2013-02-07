Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3BGVWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:22:00 -0500
Received: from 8bytes.org ([85.214.48.195]:39974 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305Ab3BGVV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:21:59 -0500
Date: Thu, 7 Feb 2013 22:21:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
Message-ID: <20130207212145.GE2849@8bytes.org>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
 <20130207113340.GW25591@8bytes.org>
 <CALCETrUzX9efPafJ0W2vxU-KgQ_FOxQ4YqGDKbw5z6d1P0ZYEQ@mail.gmail.com>
 <20130207172701.GX25591@8bytes.org>
 <1360270958.6066.166.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360270958.6066.166.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Feb  7 22:21:57 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51141af522971788488681
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 09:02:38PM +0000, David Woodhouse wrote:
> Backtraces add visibility and have proven to be extremely useful in the
> past for getting people to actually *fix* broken BIOSes.
> 
> When kerneloops.org was running, it also gave very good statistics which
> helped to apply pressure.

That is true in general, but does not apply to the two warnings in
question here. One warning checks for a hypothetical hardware problem
and the other warning could happen for several reasons, not only a
firmware bug.

It would make sense to put a warning in the respective places where a
firmware problem is detected, though. The parse_ioapics_under_ir()
function is a candidate where it would make sense, for example. But in
the error path of the intel_enable_irq_remapping() function a pr_warn
would do the same job.


	Joerg


