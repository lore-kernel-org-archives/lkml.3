Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaETU2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:28:07 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35139 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbaETU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:28:06 -0400
Date: Tue, 20 May 2014 21:27:55 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [GIT PULL] EFI changes for v3.16
Message-ID: <20140520202755.GI4798@console-pimps.org>
References: <20140503130447.GW26088@console-pimps.org>
 <20140519105129.GF4798@console-pimps.org>
 <537A8A03.8060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A8A03.8060604@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May, at 03:47:31PM, H. Peter Anvin wrote:
> 
> How on earth does this solve anything?  The only thing we add here is a
> WARN_ON_ONCE()... but the above text already tells us we have a problem.
> 
> It seems, rather, that we need to figure out how to deal with a pstore
> in this case.  There are a few possibilities:
> 
> 1. We could keep an XSAVE buffer area around for this particular use.
>    I am *assuming* we don't let more than one CPU into EFI, because I
>    cannot for my life imagine that this is safe in typical CPUs.
 
Correct. This is actually prohibited by the spec, so we have a lock to
enforce it.

> 2. Drop the pstore on the floor if !irq_fpu_usable().
> 
> 3. Allow the pstore, then die (on the assumption that we're dead
>    anyway.)

Personally, I'd prefer 2, but I'm open to suggestions.

-- 
Matt Fleming, Intel Open Source Technology Center
