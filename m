Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3E1Kuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:50:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37108 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab3E1Kup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:50:45 -0400
Date: Tue, 28 May 2013 11:50:41 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130528105041.GP14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524200539.GA3322@sgi.com>
 <1369426255.2217.9.camel@x230>
 <20130524204937.GB3322@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524204937.GB3322@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May, at 03:49:38PM, Russ Anderson wrote:
> Why does the kernel still try to create /sys/firmware/efivars/
> entries in the original failure even though efi_call_phys4()
> failed?  Or does it always try to create those entries
> and GetNextVariable() blows up in the original failure
> but not in my experiment?

CONFIG_EFI_VARS will try to create /sys/firmware/efivars even without
the additional info from the early EFI boot variable code. The early
variable code is only a heuristic that is supposed to improve the
anti-bricking algorithm in the EFI variable code.

-- 
Matt Fleming, Intel Open Source Technology Center
