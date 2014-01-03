Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbaACENt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 23:13:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaACENr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 23:13:47 -0500
Date: Fri, 3 Jan 2014 12:12:37 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Message-ID: <20140103041237.GA4506@dhcp-16-198.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
 <20140102024256.GB2563@darkstar.nay.redhat.com>
 <20140102103549.GC2618@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102103549.GC2618@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please send these as separate patches and include the compiler errors in
> the commit message. I'll pick them up and send them to Peter.

Sent.

>  
> > build fix: move parse_efi_setup to efi*.c, call it in efi_init instead in setup.c
> 
> Why have you moved the call site for parse_efi_setup()? What's the
> rationale? Parsing SETUP_* entries outside of parse_setup_data() seems
> to me to be a step backwards in terms of clarity.

SETUP_PCI also duplicate the parsing logic out of setup.c.
I added static inline in ifdef else branch, but I got some warnings yestoday
about "unused function", double checked it today there's no such warnings
anymore, it might be caused by some mistake.

Changed to static inline {} in patches I just sent a moment ago.

Thanks
Dave
