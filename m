Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaDXGWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:22:23 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60488 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaDXGWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:22:21 -0400
Date: Thu, 24 Apr 2014 08:22:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140424062217.GA1104@gmail.com>
References: <5357D07C.5080407@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357D07C.5080407@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Twaig <oren@scalemp.com> wrote:

> Set all inclusive vector allocation domain only if interrupt routing
> is set to ignore. When in comply mode, vector allocation behavior
> isn't changed.

This changelog is too terse:

Please update the changelog to describe the current behavior, and how 
it affects your platform. (I.e. how do users notice, if at all?)

Then describe why you think that behavior should be changed. ie: 
what's the reason for this patch.

Only then describe the details of the change itself.

> -    apic->vector_allocation_domain = fill_vector_allocation_domain;
> +
> +    if (!irc)
> +        apic->vector_allocation_domain = fill_vector_allocation_domain;

Please also run scripts/checkpatch.pl over your patch which will 
report trivial coding style problems like the one here.

Thanks,

	Ingo
