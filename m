Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3KGVjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:39:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:20147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab3KGVjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:39:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,654,1378882800"; 
   d="scan'208";a="429674796"
Date: Thu, 7 Nov 2013 13:39:44 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, catalin.marinas@arm.com,
        will.deacon@arm.com, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, steve.capper@linaro.org
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
Message-ID: <20131107213944.GJ1962@tassilo.jf.intel.com>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
 <527C0195.50008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527C0195.50008@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 01:09:41PM -0800, H. Peter Anvin wrote:
> On 11/07/2013 09:17 AM, Ard Biesheuvel wrote:
> > This series implements automatic module loading based on optional CPU features,
> > and tries to do so in a generic way. Currently, 32 feature bits are supported,
> > and how they map to actual CPU features is entirely up to the architecture.
> 
> NAK.
> 
> We in the x86 world already left 32 bits way behind; we currently have
> 320 bit feature masks.
> 
> If you're aiming at doing this in a generic way, it needs to be able to
> accommodate the current x86cpu feature stuff as a subset, which this
> doesn't.

They can just use the exact same code/macros as x86cpu, just need a different 
prefix and use wildcards if they miss something (e.g. family)

-Andi
