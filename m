Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaIDHkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:40:14 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57861 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaIDHkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:40:13 -0400
Date: Thu, 4 Sep 2014 08:40:08 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140904074008.GJ3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
 <20140902192941.GB3001@console-pimps.org>
 <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
 <5406D0DB.90401@canonical.com>
 <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
 <20140903175948.GH3001@console-pimps.org>
 <54078C74.2060804@zytor.com>
 <CAKv+Gu8VkW+unei3vGZxor6ZGuLwsmKktcBJfy3+bKrkrKgPyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8VkW+unei3vGZxor6ZGuLwsmKktcBJfy3+bKrkrKgPyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep, at 08:47:57AM, Ard Biesheuvel wrote:
> 
> So how about we:
> - add ASSERT(_got == _egot, "GOT entries not supported in
> boot/compressed") to the linker script
> - #define __nogotentry __attribute__((visibility(hidden))) somewhere
> in compiler.h or wherever else it belongs
> - add the __nogotentry qualifiers to each extern that requires it,
> which is currently:
> early_serial_base
> efi_early
> free_mem_end_ptr
> free_mem_ptr
> real_mode
> - get rid of the fixup code in assembly
 
Seems fine to me since it was Peter who introduced the GOT fixup asm
code in the first place.

> Any idea what the oldest GCC is we should support?

I'm pretty sure we still support GCC 3.x.x. The symbol visibility
support was added in GCC 4.x right?

-- 
Matt Fleming, Intel Open Source Technology Center
