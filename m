Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970AbaABKgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:36:13 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54620 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbaABKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:36:11 -0500
Date: Thu, 2 Jan 2014 10:35:49 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Message-ID: <20140102103549.GC2618@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
 <20140102024256.GB2563@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102024256.GB2563@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jan, at 10:42:56AM, Dave Young wrote:
> 
> Hi, Matt
> 
> randconfig build robot reports several problems:
> 1. sparse warnings which should be fixed by the early_memremap patches

Yeah, this will be fixed up when Mark's memremap patch series gets
merged.

> Here is the fix for 2. and 3, please take a look. I'm not sure if I
> should resend the patches or leave them to you.
 
Please send these as separate patches and include the compiler errors in
the commit message. I'll pick them up and send them to Peter.
 
> build fix: move parse_efi_setup to efi*.c, call it in efi_init instead in setup.c

Why have you moved the call site for parse_efi_setup()? What's the
rationale? Parsing SETUP_* entries outside of parse_setup_data() seems
to me to be a step backwards in terms of clarity.

-- 
Matt Fleming, Intel Open Source Technology Center
