Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3FSQSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:18:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38056 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSQSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:18:34 -0400
Date: Wed, 19 Jun 2013 18:18:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619161827.GF28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130619160804.GB27832@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 05:08:04PM +0100, Matthew Garrett wrote:
> But, as always, the only reliable thing to do here is to behave as
> much like Windows as possible. Which means performing the 1:1 mapping
> but maintaining the high mapping, and passing the high values via
> SetVirtualAddressMap.

We can't pass the high values via SetVirtualAddressMap and have EFI
runtime in the kexec-ed kernel, as you and I established last week. And
since not all would want EFI runtime in the kexec-ed kernel, I'm leaning
more towards a boot-time option which enables the 1:1 mapping.

Btw, why would you even want the 1:1 mappings if we pass the high values
via SetVirtualAddressMap?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
